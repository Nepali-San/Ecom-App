import 'package:practise_app1/models/product.dart';
import 'package:practise_app1/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import '../models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedProducts extends Model {
  List<Product> _products = [];
  String _selProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addproduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2018/02/valentines-day-2057745_1920.jpg?itok=IFpejN6h&fc=50,50",
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };

    try {
      final http.Response response = await http.post(
          'https://flutter-products-ec3de.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      Product p = new Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email,
          image: image);

      _products.add(p);
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

  List<Product> get allproducts => List.from(_products);

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

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    int backupIndex = selectedProductIndex;
    Product backup = _products[backupIndex];

    _products.removeAt(backupIndex);
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
      _products.insert(backupIndex, backup);
      notifyListeners();
      return false;
    });
  }

  Future<bool> updateProduct(
    String title,
    String description,
    String image,
    double price,
  ) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateProduct = {
      'title': title,
      'description': description,
      'image':
          "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2018/02/valentines-day-2057745_1920.jpg?itok=IFpejN6h&fc=50,50",
      'price': price,
      'userId': selectedProduct.id,
      'userEmail': selectedProduct.userEmail,
    };

    return http
        .put(
            'https://flutter-products-ec3de.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateProduct))
        .then((http.Response response) {
      Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email,
          image:
              "https://www.popsci.com/sites/popsci.com/files/styles/1000_1x_/public/images/2018/02/valentines-day-2057745_1920.jpg?itok=IFpejN6h&fc=50,50");

      _products[selectedProductIndex] = updatedProduct;

      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void selectProduct(String id) {
    _selProductId = id;
  }

  void toogleFavourite() {
    bool isCurrentFavourite = selectedProduct.isFavorite;
    bool newFavouriteStatus = !isCurrentFavourite;
    final updatedProduct = new Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        image: selectedProduct.image,
        description: selectedProduct.description,
        price: selectedProduct.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavouriteStatus);

    _products[selectedProductIndex] = updatedProduct;
    _selProductId = null;
    notifyListeners();
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
    notifyListeners();

    return http
        .get(
            'https://flutter-products-ec3de.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
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
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;

      _isLoading = false;
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
    });
  }
}

mixin UserModel on ConnectedProducts {

  User get user{
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

      final SharedPreferences prefs =  await SharedPreferences.getInstance();
      prefs.setString("token", info['idToken']);
      prefs.setString("id", info['localId']);
      prefs.setString("email", email);

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

  void autoAuth() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if(token != null){
      final String id = prefs.getString('id');
      final String email = prefs.getString('email');

       _authenticatedUser = User(
        id: id,
        email: email,
        token: token,
      );
      notifyListeners();
    }

  }

}


mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
