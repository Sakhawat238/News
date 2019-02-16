import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';
import 'dart:async';

class CommentsBloc {
  final _commentFetcherController = PublishSubject<int>();
  final _commentOuputController = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _repository = Repository();

  //streams...
  Observable<Map<int,Future<ItemModel>>> get itemWithComments => _commentOuputController.stream;


  //sink......
  Function(int) get  fetchItemWithComments => _commentFetcherController.sink.add;


  CommentsBloc(){
    _commentFetcherController.stream.transform(_commentsTransformer()).pipe(_commentOuputController);
  }

  _commentsTransformer(){
    return ScanStreamTransformer<int,Map<int,Future<ItemModel>>>(
      (cache, int id, index){
        cache[id] = _repository.fetchItem(id);
        cache[id].then((ItemModel item){
          item.kids.forEach((kidId)=>fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{}
    );
  }

  void dispose(){
    _commentFetcherController.close();
    _commentOuputController.close();
  }
}