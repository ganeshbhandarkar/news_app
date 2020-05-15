import 'package:flutter/material.dart';
import 'package:newsapp/helper/news.dart';
import 'package:newsapp/helper/data.dart';
import 'package:newsapp/models/Article.dart';
import 'package:newsapp/models/CategorieModel.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/category_news.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  List<CategorieModel> categories = new List<CategorieModel>();
  List<Article> articles = new List<Article>();

  bool _isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    _getArticles();
  }


  void _getArticles() async{

    News news = News();
    await news.getNews();
    articles = news.news;
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
      body: _isloading ? Container(child: Center(child: CircularProgressIndicator(),),):SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
               Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (cxt, index){
                      return CategoryTile(
                        imageUrl: categories[index].imageAssetUrl,
                        categoryName: categories[index].categorieName,
                      );
                    },
                  ),
              ),

              // Articles

              Container(
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
              )

            ],
          ),),
      )
//      ): Container(width: MediaQuery.of(context).size.width,child: Center(child: CircularProgressIndicator(),),),
    );
  }
}

class CategoryTile extends StatelessWidget {

  final imageUrl,categoryName;
  CategoryTile({this.imageUrl,this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryView(category: categoryName.toString().toLowerCase())));
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 120,
                  height: 60,
                  decoration: BoxDecoration(
                      image: new DecorationImage(image: NetworkImage(imageUrl),colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4),
                          BlendMode.dstATop),fit: BoxFit.cover)
                  ),
                ),
              ),
//            ClipRRect(
//              borderRadius: BorderRadius.circular(10),
//              child: Image(
//                image: NetworkImage(imageUrl,),
//                width: 120,
//                height: 60,
//                fit: BoxFit.cover,
//              ),
//            ),
              Container(
                alignment: Alignment.center,width: 120,height: 60,
                child: Text(
                  categoryName,
                ),
              )
            ],
          ),
        ),
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

