import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:practise_app1/models/product.dart';
import 'package:practise_app1/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import '../models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'dart:async';
import 'package:mime/mime.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  List<Product> _myProducts;

  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutter-products-ec3de.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath('image', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print("Something went wrong");
        print(json.decode(response.body));        
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addproduct(String title, String description, File image,
      double price, String address) async {
    _isLoading = true;
    notifyListeners();

    final uploadData = await uploadImage(image);
    if(uploadData == null){
      print("Upload failed");
      return false;
    }



    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'imagePath':
          uploadData['imagePath'],
      'imageUrl':uploadData['imageUrl'],
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'address': address,
    };

    try {
      final http.Response response = await http.post(
          'https://flutter-products-ec3de.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      final Map<String, dynamic> responseData = json.decode(response.body);

      Product p = new Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email,
          address: address,
          image: uploadData['imageUrl']);

      _products.add(p);
      _myProducts.add(p);

      _selProductId = null;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

mixin ProductModel on ConnectedProducts {
  bool _showFavourites = false;

  //use _myProducts to keep a seprate list of product belonging to _authenticate user
  //rem to update it while updating database.

  List<Product> get allproducts => List.from(_products);

  List<Product> get myproducts => _myProducts;

  void resetMyProducts() => _myProducts.clear();

  int get selectedProductIndex {
    if (_selProductId == null) return null;
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  List<Product> get displayProducts {
    if (_showFavourites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) return null;
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  /*
    we delete the data from list _myProducts(to update list UI) and from database(as delete is supposed to do it),
    _products(also _myProducts) will be automatically updated on fetching data when we navigate back to home page.
  */

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    int backupIndex = _myProducts.indexWhere((Product product) {
      return product.id == _selProductId;
    });

    int productbackupIndex = selectedProductIndex;

    Product backup = _myProducts[backupIndex];

    _myProducts.removeAt(backupIndex);
    _products.removeAt(productbackupIndex);

    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-ec3de.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;

      _myProducts.insert(backupIndex, backup);
      _products.insert(productbackupIndex, backup);

      notifyListeners();
      return false;
    });
  }

  /*we update original product in database and navigate to homepage 
  where _myProducts & _products is automatically reloaded so we don't update 
  those lists as in delete operation*/

  Future<bool> updateProduct(
    String title,
    String description,
    String image,
    double price,
    String address,
  ) async {
    _isLoading = true;
    notifyListeners();

    String imgUrl =
        "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2018/02/valentines-day-2057745_1920.jpg?itok=IFpejN6h&fc=50,50";

    try {
      //we retrieve the current wishListUsers(users that has favourited this product) and then put it in updated list.
      http.Response res = await http.get(
          "https://flutter-products-ec3de.firebaseio.com/products/${selectedProduct.id}/wishListUsers.json?auth=${_authenticatedUser.token}");

      final Map<String, dynamic> updateProduct = {
        'title': title,
        'description': description,
        'image': imgUrl,
        'price': price,
        'userId': selectedProduct.userId,
        'userEmail': selectedProduct.userEmail,
        'address': address,
        'wishListUsers': json.decode(res.body),
      };

      final Product updatedProductlocal = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: imgUrl,
          address: address,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      await http.put(
          'https://flutter-products-ec3de.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateProduct));

      //Now update both list locally too...

      _products[selectedProductIndex] = updatedProductlocal;

      //same as above, we are not only having a getter for it...
      int myProductIndex = _myProducts.indexWhere((Product p) {
        return p.id == selectedProductId;
      });

      _myProducts[myProductIndex] = updatedProductlocal;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void selectProduct(String id) {
    _selProductId = id;
  }

  /* 
  _myProducts has no concern with favourite feature so we only update database and (_products).
  */

  void toogleFavourite() async {
    bool isCurrentFavourite = selectedProduct.isFavorite;
    bool newFavouriteStatus = !isCurrentFavourite;

    String addLikeUrl =
        "https://flutter-products-ec3de.firebaseio.com/products/$selectedProductId/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}";
    String delLikeUrl =
        "https://flutter-products-ec3de.firebaseio.com/products/$selectedProductId/wishListUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}";

    //updating the product locally , revert it if not success...
    final updatedProduct = new Product(
        id: selectedProductId,
        title: selectedProduct.title,
        image: selectedProduct.image,
        description: selectedProduct.description,
        price: selectedProduct.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        address: selectedProduct.address,
        isFavorite: newFavouriteStatus);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();

    //may use try catch instead of checking the response status code...
    try {
      if (newFavouriteStatus) {
        await http.put(
          addLikeUrl,
          body: json.encode(true),
        );
      } else {
        await http.delete(
          delLikeUrl,
        );
      }
    } catch (error) {
      final updatedProduct = new Product(
          id: selectedProductId,
          title: selectedProduct.title,
          image: selectedProduct.image,
          description: selectedProduct.description,
          price: selectedProduct.price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          address: selectedProduct.address,
          isFavorite: !newFavouriteStatus);

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
    _selProductId = null;
  }

  void toogelMode() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }

  bool get showOnlyFavourites {
    return _showFavourites;
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    String fetchUrl =
        'https://flutter-products-ec3de.firebaseio.com/products.json?auth=${_authenticatedUser.token}';
    notifyListeners();

    return http.get(fetchUrl).then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = new Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userId: productData['userId'],
          userEmail: productData['userEmail'],
          address: productData['address'],
          isFavorite: productData['wishListUsers'] != null
              ? (productData['wishListUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id)
              : false,
        );
        fetchedProductList.add(product);
      });

      _products = fetchedProductList;

      _myProducts = _products.where((Product product) {
        return product.userId == _authenticatedUser.id;
      }).toList();

      _isLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin UserModel on ConnectedProducts {
  Timer _authTimer;

  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [authmode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    http.Response responseData;
    //to handle the error when no internet , i used try catch..
    try {
      if (authmode == AuthMode.Login) {
        responseData = await http.post(
          "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyB3mdnqefEFT7Hih8U62iO3EBDCw5XnwJA",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        responseData = await http.post(
            "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyB3mdnqefEFT7Hih8U62iO3EBDCw5XnwJA",
            body: json.encode(authData),
            headers: {'Content-Type': 'application/json'});
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': "connection problem !!!",
      };
    }

    final Map<String, dynamic> info = json.decode(responseData.body);

    bool hasError = true;
    String msg = "Something went wrong";

    if (info.containsKey('idToken')) {
      hasError = false;
      msg = 'Authentication succeeded';
      _authenticatedUser = User(
        id: info['localId'],
        email: email,
        token: info['idToken'],
      );

      _userSubject.add(true);
      setAuthTimeout(int.parse(info['expiresIn']));

      final DateTime now = DateTime.now();
      final DateTime expirytime =
          now.add(Duration(seconds: int.parse(info['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", info['idToken']);
      prefs.setString("id", info['localId']);
      prefs.setString("email", email);
      prefs.setString("expiryTime", expirytime.toIso8601String());
    } else if (info['error']['message'] == 'EMAIL_NOT_FOUND') {
      msg = 'This email id was not found !!!';
    } else if (info['error']['message'] == 'INVALID_PASSWORD') {
      msg = 'Your password is not valid !!!';
    } else if (info['error']['message'] == 'EMAIL_EXISTS') {
      msg = 'Email already used !!!';
    }

    _isLoading = false;
    notifyListeners();

    return {
      'success': !hasError,
      'message': msg,
    };
  }

  void autoAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTime = prefs.getString("expiryTime");

    if (token != null) {
      final DateTime now = DateTime.now();
      final DateTime expiryTimeParsed = DateTime.parse(expiryTime);
      if (expiryTimeParsed.isBefore(now)) {
        _authenticatedUser = null;
        print("old token");
        notifyListeners();
        return;
      }

      final String id = prefs.getString('id');
      final String email = prefs.getString('email');
      final int tokenLifeSpans = expiryTimeParsed.difference(now).inSeconds;

      _authenticatedUser = User(
        id: id,
        email: email,
        token: token,
      );

      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpans);

      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('id');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
