import 'package:flutter/material.dart';
import 'package:newsapp/helper/news.dart';
import 'package:newsapp/models/Article.dart';
import 'package:newsapp/views/article_view.dart';

class CategoryView extends StatefulWidget {

  String category;

  CategoryView({this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  bool _isloading = true;
  List<Article> articles = new List<Article>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategoryArticles();
  }

  void _getCategoryArticles() async{

    CategoryNews categoryNews = CategoryNews();
    await categoryNews.getNewsForCategory(widget.category);
    articles = categoryNews.news;
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News App"),
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
      ),
      body: Container(
        child: ListView.builder(itemCount: articles
            .length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (cxt,index){
              return BlogTile(
                imageUrl: articles[index].urlToImage,
                title: articles[index].title,
                description: articles[index].description,
                url: articles[index].articleUrl,
              );
            }),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  String imageUrl;
  String title;
  String description;
  String url;

  BlogTile({
    this.imageUrl,this.title,this.description,this.url
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleView(url: url,)));
      },
      child: Card(
        borderOnForeground: true,
        color: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.network(imageUrl,fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,letterSpacing: 1.3),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Text(description,style: TextStyle(letterSpacing: 0.5),softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 2,),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

