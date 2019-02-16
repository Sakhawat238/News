import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget{
  final int itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    //bloc.fetchItem(itemId);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int,Future<ItemModel>>> snapshot){
        if(!snapshot.hasData){
          return loadingListTile();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot){
            if(!itemSnapshot.hasData){
              return loadingListTile();
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(item.title),
          subtitle: Text('${item.score} votes'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${item.descendants}'),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(context, '/${item.id}');
          },
        ),
        Divider(),
      ],
    );
  }

  Widget loadingListTile(){
    return Column(
      children: <Widget>[
        ListTile(
          title: Container(
            color: Colors.grey[200],
            height: 24.0,
            width: 150.0,
            margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
          ),
          subtitle: Container(
            color: Colors.grey[100],
            height: 14.0,
            width: 50.0,
            margin: EdgeInsets.only(top: 3.0,bottom: 3.0),
          ),
        ),
        Divider(),
      ],
    );
  }
}