import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../models/auth_token.dart';
import '../../services/carts_service.dart';
import 'package:flutter/foundation.dart';


class CartManager with ChangeNotifier{
  List< CartItem> _items = [];

  final CartsService _cartsService;

  CartManager([AuthToken? authToken])
    : _cartsService = CartsService(authToken);

  set authToken(AuthToken? authToken){
    _cartsService.authToken = authToken;
  }

  Future<void> fetchCarts([bool filterByUser = true]) async {
    _items = await _cartsService.fetchCarts(filterByUser);
    print(_items);
    notifyListeners();
  }

  // Future<void> addCart(CartItem cart) async {
  //   final newCart = await _cartsService.addCart(cart);
  //   if(newCart != null){
  //     _items.add(newCart);
  //     notifyListeners();
  //   }
  // }

  int get productCount{
    return _items.length;
  }
  int get itemCount{
    return _items.length;
  }

  List<CartItem> get products{
    return _items.toList();
  }

  List<CartItem> get productEntries{
    return [..._items];
  }

  double get totalAmount{
    var total = 0.0;
    for(var i = 0; i < _items.length; i++){
        total+= _items[i].price * _items[i].quantity;
    }
    return total;
  }

  Future<void> addItem(Product product) async {
    
    bool check = false;
    for(var i = 0; i < _items.length; i++){
      if(_items[i].productId == product.id){
        check = true;
      }
    }
    if(check){
      int tmp = 0;
      for(var i = 0; i < _items.length; i++){
        if(_items[i].productId == product.id){
          _items[i] = CartItem(
              id:  _items[i].id,
              productId: _items[i].productId,
              title: _items[i].title,
              imageUrl: _items[i].imageUrl,
              price: _items[i].price,
              quantity: _items[i].quantity + 1,
            );
          tmp = i;
          await _cartsService.updateCart(_items[i]);
        }
      }
    } else {
      String IDcart =  'c${DateTime.now().toIso8601String()}';
      final newCart = await _cartsService.addCart(CartItem(
                        id: IDcart,
                        productId: product.id.toString(),
                        title: product.title,
                        imageUrl: product.imageUrl,
                        price: product.price,
                        quantity: 1,
                      ),);
      if(newCart != null){
        _items.add(newCart);
        notifyListeners();
      }
      // await _cartsService.addCart(CartItem(
      //     id: IDcart,
      //     productId: product.id.toString(),
      //     title: product.title,
      //     imageUrl: product.imageUrl,
      //     price: product.price,
      //     quantity: 1,
      //   ));
    }
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    int tmp = _items.indexWhere((element) => element.productId == productId);
    await _cartsService.deleteCart(_items[tmp].id.toString());
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    // int tmp = -1;
    int tmp = _items.indexWhere((element) => element.productId == productId);
    if(tmp < 0){
      return;
    }
    var index = _items.indexWhere((element) => element.productId == productId);
    if(_items[index].quantity as num > 1){

      _items[index] = CartItem(
          id: _items[index].id,
          productId: _items[index].productId,
          title: _items[index].title,
          imageUrl: _items[index].imageUrl,
          price: _items[index].price,
          quantity: _items[index].quantity - 1,
        );
      await _cartsService.updateCart(_items[index]);
    }else {
      var index = _items.indexWhere((element) => element.productId == productId);
      await _cartsService.deleteCart(_items[index].id.toString());
      _items.removeWhere((item) => item.productId == productId);
    }
    notifyListeners();
  }

  Future<void> clear() async {
    for(var i = 0; i < _items.length; i++){
      await _cartsService.deleteCart(_items[i].id.toString());
    }
    _items = [];
    notifyListeners();
  }
}