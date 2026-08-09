
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
// import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_event.dart';

// import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_statet.dart';
// import '../widgets/book_card.dart';
// import 'filter_bottom_sheet.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // متغيرات الفلترة
//   int? selectedCategoryId;
//   String? authorName;
//   String? selectedLanguage;
//   int? pagesFrom;
//   int? pagesTo;
//   double? priceFrom;
//   double? priceTo;

//   // قائمة تصنيفات تجريبية (يمكنكِ تعبئتها ديناميكياً من الـ Category Bloc لاحقاً)
//   final List<Map<String, dynamic>> _categories = [
  //   {'id': null, 'name': 'الكل'},
  //   {'id': 1, 'name': 'literature'},
  //   {'id': 2, 'name': 'horror'},
  //   {'id': 3, 'name': 'history'},
  //   {'id': 4, 'name': 'poetry '},
  //  {'id': 4, 'name': 'science'},
  //   {'id': 4, 'name':'fantasy'},
  //   {'id': 4, 'name':'adventure'},
  //       //    {'id': 4, 'name': 'self_development'},
  //       //    {'id': 4, 'name':'business'},
  //       //    {'id': 4, 'name':'marketing'},
  //       //    {'id': 4, 'name':'finance'},
  //       //    {'id': 4, 'name':'programming'},
  //       //    {'id': 4, 'name':'data_science'},
  //       //    {'id': 4, 'name':'physics'},
  //       //    {'id': 4, 'name':'chemistry'},
  //       //    {'id': 4, 'name':'biology'},
  //       //    {'id': 4, 'name':'astronomy'},
  //       //    {'id': 4, 'name':'education'},
  //       //    {'id': 4, 'name':'art'},
  //       //    {'id': 4, 'name':'cooking'},
  //       //    {'id': 4, 'name':'health'},
  //       //    {'id': 4, 'name':'children'},
  //       // //  'statistics','academic_books','comics','sports','parenting','family_relationships'
  // ];

//   void _dispatchSearch() {
//     context.read<SearchBloc>().add(
//       ExecuteBookSearch(
//         bookName: _searchController.text,
//         authorName: authorName, // تفعيل إرسال اسم المؤلف
//         categoryId: selectedCategoryId, // تفعيل إرسال التصنيف المطلوب
//         language: selectedLanguage,
//         numberOfPagesFrom: pagesFrom,
//         numberOfPagesTo: pagesTo,
//         sellingPriceFrom: priceFrom,
//         sellingPriceTo: priceTo,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(172, 181, 225, 239),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(112, 29, 105, 133),
//         elevation: 0,
//         title: TextField(
//           controller: _searchController,
//           autofocus: true,
//           style: const TextStyle(color: Color.fromARGB(255, 240, 230, 230)),
//           decoration: const InputDecoration(
//             hintText: "ابحث باسم الكتاب...",
//             hintStyle: TextStyle(color: Color.fromARGB(153, 16, 14, 14)),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) => _dispatchSearch(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.tune, color: Colors.white),
//             onPressed: () async {
//               final result = await showModalBottomSheet<Map<String, dynamic>>(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (_) => const FilterBottomSheet(),
//               );

//               if (result != null) {
//                 setState(() {
//                   authorName = result['author_name'];
//                   selectedLanguage = result['language'];
//                   pagesFrom = result['pages_from'];
//                   pagesTo = result['pages_to'];
//                   priceFrom = result['price_from'];
//                   priceTo = result['price_to'];
//                 });
//                 _dispatchSearch();
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // 🏷️ تحسين التصميم: قائمة التصنيفات الأفقية الذكية
//           Container(
//             height: 60,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _categories.length,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemBuilder: (context, index) {
//                 final cat = _categories[index];
//                 final isSelected = selectedCategoryId == cat['id'];
//                 return Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: ChoiceChip(
//                     label: Text(cat['name']),
//                     selected: isSelected,
//                     selectedColor: const Color.fromARGB(255, 31, 69, 91),
//                     backgroundColor: const Color.fromARGB(255, 173, 199, 255),
//                     labelStyle: TextStyle(
//                       color: isSelected ? const Color.fromARGB(255, 27, 23, 23) : Colors.white70,
//                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                     ),
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategoryId = selected ? cat['id'] : null;
//                       });
//                       _dispatchSearch(); // تحديث البحث فوراً عند تغيير التصنيف
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
          
//           // نتائج البحث
//           Expanded(
//             child: BlocBuilder<SearchBloc, SearchState>(
//               builder: (context, state) {
//                 if (state is SearchLoading) {
//                   return const Center(child: CircularProgressIndicator(color: Colors.white));
//                 } else if (state is SearchSuccess) {
//                   final books = state.books;
//                   if (books.isEmpty) {
//                     return const Center(
//                       child: Text("لم نجد أي كتب تطابق بحثكِ", style: TextStyle(color: Colors.white70)),
//                     );
//                   }
//                   return Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: GridView.builder(
//                       itemCount: books.length,
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 12,
//                         crossAxisSpacing: 12,
//                         childAspectRatio: 0.65,
//                       ),
//                       itemBuilder: (context, index) => BookCard(book: books[index]),
//                     ),
//                   );
//                 } else if (state is SearchFailure) {
//                   return Center(
//                     child: Text(state.errorMessage, style: const TextStyle(color: Colors.redAccent)),
//                   );
//                 }
//                 return const Center(
//                   child: Text("اكتب اسم الكتاب أو استخدم الفلاتر لبدء البحث", style: TextStyle(color: Colors.white60)),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_bloc.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_event.dart';
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_statet.dart';
import '../widgets/book_card.dart';
import 'filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  int? selectedCategoryId;
  String? authorName;
  String? selectedLanguage;
  int? pagesFrom;
  int? pagesTo;

  
  double? sellingPriceFrom;
  double? sellingPriceTo;
  double? rentalPriceFrom;
  double? rentalPriceTo;

  
  final List<Map<String, dynamic>> _staticCategories = [
    {'id': 1, 'name': 'literature'},
    {'id': 2, 'name': 'horror'},
    {'id': 3, 'name': 'history'},
    {'id': 4, 'name': 'poetry '},
    {'id': 5, 'name': 'science'},
    {'id': 6, 'name':'fantasy'},
    {'id': 7, 'name':'adventure'},
    {'id': 8, 'name': 'self_development'},
    {'id': 9, 'name':'business'},
    {'id': 10, 'name':'marketing'},
    {'id': 11, 'name':'finance'},
    {'id': 12, 'name':'programming'},
    {'id': 13, 'name':'data_science'},
    {'id': 14, 'name':'physics'},
    {'id': 15, 'name':'chemistry'},
    {'id': 16, 'name':'biology'},
    {'id': 17, 'name':'astronomy'},
    {'id': 18, 'name':'education'},
    {'id': 19, 'name':'art'},
    {'id': 20, 'name':'cooking'},
    {'id': 21, 'name':'health'},
    {'id': 22, 'name':'children'},
    {'id': 23, 'name':'statistics'},
    {'id': 24, 'name':'academic_books'},
    {'id': 25, 'name':'comics'},
    {'id': 26, 'name':'sports'},
    {'id': 27, 'name':'parenting'},
    {'id': 28, 'name':'family_relationships'}
  ];

  //  تعديل الدالة لترسل المتغيرات المنفصلة للـ Bloc ومنه للـ API
  void _dispatchSearch() {
    context.read<SearchBloc>().add(
      ExecuteBookSearch(
        bookName: _searchController.text,
        authorName: authorName, 
        categoryId: selectedCategoryId, 
        language: selectedLanguage,
        numberOfPagesFrom: pagesFrom,
        numberOfPagesTo: pagesTo,
       
        sellingPriceFrom: sellingPriceFrom,
        sellingPriceTo: sellingPriceTo,
        rentalPriceFrom: rentalPriceFrom,
        rentalPriceTo: rentalPriceTo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 238, 240),
      appBar: AppBar(
        backgroundColor:  const Color(0xffc9b6f5),
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Color.fromARGB(255, 254, 251, 251)),
          decoration: const InputDecoration(
            hintText: "Search by Book Title..",
            hintStyle: TextStyle(color: Color.fromARGB(255, 251, 251, 251)),
            border: InputBorder.none,
          ),
          onChanged: (value) => _dispatchSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FilterBottomSheet(),
              );

             
              if (result != null) {
                setState(() {
                  authorName = result['author_name'];
                  selectedLanguage = result['language'];
                  pagesFrom = result['pages_from'];
                  pagesTo = result['pages_to'];
                  
                  // ربط حقول أسعار البيع والإيجار بشكل منفصل تماماً
                  sellingPriceFrom = result['selling_price_from'];
                  sellingPriceTo = result['selling_price_to'];
                  rentalPriceFrom = result['rental_price_from'];
                  rentalPriceTo = result['rental_price_to'];
                });
                _dispatchSearch();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
         
         Container(
  height: 50,
  padding: const EdgeInsets.symmetric(vertical: 6),
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: _staticCategories.length + 1, // +1 من أجل زر "الكل"
    padding: const EdgeInsets.symmetric(horizontal: 12),
    itemBuilder: (context, index) {
      final bool isAll = index == 0;
      final category = isAll ? null : _staticCategories[index - 1];
      final isSelected = isAll 
          ? selectedCategoryId == null 
          : selectedCategoryId == category!['id'];

      final String label = isAll ? 'الكل' : category!['name'];

      return GestureDetector(
        onTap: () {
          setState(() {
            selectedCategoryId = isAll ? null : category!['id'];
          });
          _dispatchSearch();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(left: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // اللون الأصفر الدائري للمحدد والبنفسجي للغير محدد
            color: isSelected 
                ? const Color(0xFFFFE57F) // أصفر مائل الذهبي الفاتح
                : const Color(0xFFC9B6F5), // البنفسجي
            borderRadius: BorderRadius.circular(25), // يجعل الشكل كبسولة/دائري
            
            // إضافة التوهج الأصفر (Glow Effect) عند التحديد
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFE57F).withOpacity(0.6), // لون التوهج
                      blurRadius: 12, // انتشار التوهج والنعومة
                      spreadRadius: 2, // حجم هالة التوهج
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected 
                    ? const Color(0xFF2C2C2C) // لون النص غامق عند اختيار الأصفر
                    : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    },
  ),
),
          // نتائج البحث في الـ GridView
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (state is SearchSuccess) {
                  final books = state.books;
                  if (books.isEmpty) {
                    return const Center(
                      child: Text("لم نجد أي كتب تطابق بحثكِ", style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: books.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.58,
                      ),
                      itemBuilder: (context, index) => BookCard(book: books[index],showFavorite: false,),
                    ),
                  );
                } else if (state is SearchFailure) {
                  return Center(
                    child: Text(state.errorMessage, style: const TextStyle(color: Colors.redAccent)),
                  );
                }
                return const Center(
                  child: Text("اكتب اسم الكتاب أو استخدم الفلاتر لبدء البحث", style: TextStyle(color: Colors.white60)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}