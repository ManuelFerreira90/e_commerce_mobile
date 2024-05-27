import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_mobile/components/category_container.dart';
import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/components/price_detail_product.dart';
import 'package:e_commerce_mobile/database/db.dart';
import 'package:e_commerce_mobile/models/product.dart';
import 'package:e_commerce_mobile/screen/reviews_page.dart';
import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';

class DetailProduct extends StatefulWidget {
  DetailProduct({
    super.key,
    required this.product,
    required this.ssn,
    this.isSale,
    this.restarFavoriteProducts,
    //this.idProduct,
  });

  Product product;
  final String ssn;
  final bool? isSale;
  final Function? restarFavoriteProducts;
  //final int? idProduct;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  List<Image> images = [];
  int _currentImageIndex = 0;
  bool isFavorite = false;
  late TextEditingController _searchController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _createListImage();
    _setIsFavorite();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _setIsFavorite() async {
    final bool favorite =
        await DB.instance.existFavorite(widget.product.id!, widget.ssn);
    if (mounted) {
      setState(() {
        isFavorite = favorite;
        isLoading = false;
      });
    }
  }

  Widget _returnTags() {
    if (widget.product.tags != null) {
      return Wrap(
        spacing: 5,
        children: [
          for (var i = 0; i < widget.product.tags!.length; i++)
            CategoryContainer(text: widget.product.tags![i])
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: AnimSearchBar(
            onSubmitted: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    choiceView: 3,
                    search: value,
                    ssn: widget.ssn,
                  ),
                ),
              );
            },
            width: 300,
            textController: _searchController,
            onSuffixTap: () {
              if (mounted) {
                setState(() {
                  _searchController.clear();
                });
              }
            },
          ),
        ),
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(
          color: kColorSlider,
        ),
      ) : Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: ListView(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: kColorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        height: 300,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          if (mounted) {
                            setState(() => _currentImageIndex = index);
                          }
                        },
                      ),
                      items: images,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < widget.product.images!.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentImageIndex == i ? 8.0 : 6.0,
                            height: 6.0,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? kColorSlider
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _returnTags(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 1,
                    ),
                    child: Text(
                      widget.product.title!,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PriceDetailProduct(
                          product: widget.product, isSale: widget.isSale),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewsPage(id: widget.product.id!),
                                  ));
                            },
                            child: Container(
                              width: 75,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xff2e2a1c),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  ),
                                  Text(
                                    '${widget.product.rating}',
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (isFavorite) {
                                await DB.instance.deleteProductFavorite(
                                    widget.product.id!, widget.ssn);
                              } else {
                                await DB.instance.createProductFavorite(
                                    widget.product.id!, widget.ssn);
                              }

                              if (mounted) {
                                setState(() {
                                  if (widget.restarFavoriteProducts != null) {
                                    widget.restarFavoriteProducts!(
                                        widget.product.id);
                                  }
                                  isFavorite = !isFavorite;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(isFavorite
                                          ? 'Product added to favorite'
                                          : 'Product removed from favorite')),
                                );
                              }
                            },
                            icon: isFavorite
                                ? const Icon(
                                    Icons.favorite_outlined,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.favorite_outline_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    widget.product.description!,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.product.brand != null
                              ? Container(
                                  width: 150,
                                  child: Text(
                                    'Brand: ${widget.product.brand}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Text(
                            'Stock: ${widget.product.stock}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReviewsPage(id: widget.product.id!),
                              ));
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kColorSlider,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              'Reviews',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: widget.product.stock != null && (widget.product.stock != null || widget.product.stock != 0)
                  ? OvalButton(
                      text: 'Add to cart',
                      function: () async {
                        final bool isExist = await DB.instance
                            .existCart(widget.product.id!, widget.ssn);
                        if (isExist) {
                          final int quantity = await DB.instance
                              .countProductCart(widget.ssn, widget.product.id!);
                          await DB.instance.updateCart(
                              widget.product.id!, widget.ssn, (quantity + 1));
                        } else {
                          await DB.instance.createProductCart(
                              widget.product.id!, widget.ssn);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Product added to cart'),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  _createListImage() async {
    final List<Image> copyImages = [];
    if (widget.product.images != null) {
      for (var i = 0; i < widget.product.images!.length; i++) {
        copyImages.add(Image(
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported_outlined);
          },
          image: CachedNetworkImageProvider(
            widget.product.images![i],
            maxHeight: 300,
            maxWidth: 400,
          ),
          width: 400,
          height: 300,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
      }
    }
    if (mounted) {
      setState(() {
        images = copyImages;
      });
    }
  }
}
