import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class StoriesBloc {
  final _repository = Repository();
  final _topIdsController = PublishSubject<List<int>>();
  final _itemsOutputController = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcherController = PublishSubject<int>();

  //streams.........
  Observable<List<int>> get topIds => _topIdsController.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutputController.stream;
  StoriesBloc(){
    _itemsFetcherController.stream.transform(_itemsTransformer()).pipe(_itemsOutputController);
  }

  //sinks...........
  Function(int) get fetchItem => _itemsFetcherController.sink.add;

  fetchTopIds() async{
    final ids = await _repository.fetchTopIds();
    _topIdsController.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  _itemsTransformer(){
    return ScanStreamTransformer(
          (Map<int,Future<ItemModel>> cache, int id, index){
            cache[id] = _repository.fetchItem(id);
            return cache;
          },
          <int,Future<ItemModel>>{},
    );
  }


  void dispose(){
    _topIdsController.close();
    _itemsFetcherController.close();
    _itemsOutputController.close();
  }
}
