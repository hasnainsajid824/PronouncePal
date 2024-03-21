import 'package:flutter/material.dart';

// Future<void> _showChangeProfilePictureDialog(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, state) => AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           backgroundColor: Colors.white,
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(4.0),
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(8),
//                     ),
//                     color: const Color(0xFF4E4949).withOpacity(0.1),
//                   ),
//                   child: ToggleButtons(
//                     renderBorder: false,
//                     onPressed: (int index) {
//                       state(() {
//                         for (int buttonIndex = 0;
//                         buttonIndex < isPictureSelected.length;
//                         buttonIndex++) {
//                           if (buttonIndex == index) {
//                             isPictureSelected[buttonIndex] = true;
//                           } else {
//                             isPictureSelected[buttonIndex] = false;
//                           }
//                         }
//                       });
//                     },
//                     color: Colors.black,
//                     fillColor: const Color(0xFFFFFFFF),
//                     selectedColor: kHighlightedColor,
//                     borderRadius: const BorderRadius.all(Radius.circular(8)),
//                     constraints: BoxConstraints(
//                       minHeight: 40.0,
//                       minWidth: MediaQuery.of(context).size.width * 0.30,
//                       maxHeight: 45,
//                       maxWidth: MediaQuery.of(context).size.width * 0.33,
//                     ),
//                     isSelected: isPictureSelected,
//                     children: const [
//                       Text('Picture'),
//                       Text('Avatar'),
//                     ],
//                   ),
//                 ),
//                 if (isPictureSelected[1])
//                   Column(
//                     children: [
//                       const Text('Choose avatar'),
//                       Center(
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             // CircleAvatar(
//                             //   foregroundImage: selectedImage != null
//                             //       ? (selectedImage is File
//                             //           ? FileImage(selectedImage as File)
//                             //           : AssetImage(
//                             //                   avatarList[selectedAvatarIndex])
//                             //               as ImageProvider<Object>)
//                             //       : AssetImage(
//                             //           avatarList[selectedAvatarIndex]),
//                             //   radius: 35,
//                             // ),
//                             CircleAvatar(
//                               radius: 35,
//                               backgroundImage: isPictureSelected[1]
//                                   ? AssetImage(
//                                   avatarList[selectedAvatarIndex])
//                                   : (galleryImage != null
//                                   ? FileImage(File(galleryImage!.path))
//                                   : (imageNetwork != null
//                                   ? NetworkImage(imageNetwork!)
//                                   : AssetImage(avatarList[
//                               selectedAvatarIndex]))
//                               as ImageProvider<Object>),
//                             ),
//                             Positioned.fill(
//                               child: Transform.rotate(
//                                 angle: 3.14 / 2,
//                                 child: const CircularProgressIndicator(
//                                   backgroundColor: Colors.white,
//                                   value: 0.5,
//                                   color: kPurple,
//                                   strokeWidth: 7,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text('Select avatar'),
//                       ),
//                       const Divider(),
//                       SizedBox(
//                         height: 135,
//                         width: 300,
//                         child: GridView.builder(
//                           scrollDirection: Axis.horizontal,
//                           gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 8.0,
//                             mainAxisSpacing: 8.0,
//                           ),
//                           itemCount: avatarList.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () {
//                                 state(() {
//                                   selectedImage = null;
//                                   selectedAvatarIndex = index;
//                                 });
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   image: DecorationImage(
//                                     image: AssetImage(avatarList[index]),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 if (isPictureSelected[0])
//                   Column(
//                     children: [
//                       const Text('Upload picture'),
//                       const SizedBox(
//                         height: 20.0,
//                       ),
//                       DottedBorder(
//                         color: kPurple,
//                         borderType: BorderType.RRect,
//                         radius: const Radius.circular(10),
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 1,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Column(
//                               children: [
//                                 const SizedBox(
//                                   height: 15.0,
//                                 ),
//                                 Image.asset(
//                                   'assets/images/upload.png',
//                                   height: 35,
//                                   width: 42,
//                                 ),
//                                 const SizedBox(
//                                   height: 5.0,
//                                 ),
//                                 Text(
//                                   'Upload your picture here',
//                                   style:
//                                   kFont12.copyWith(color: Colors.black),
//                                 ),
//                                 TextButton(
//                                   onPressed: () async {
//                                     await _openGallery();
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text(
//                                     'Browse',
//                                     style: kFont12.copyWith(
//                                       color: kPurple,
//                                       decoration: TextDecoration.underline,
//                                       decorationColor: kPurple,
//                                       decorationThickness: 2.0,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 15.0,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 2.0,
//                       ),
//                       const Align(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           'JPG or PNG',
//                           style: kFont8Black,
//                         ),
//                       ),
//                       const Divider(),
//                     ],
//                   ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const SizedBox(
//                         width: 40,
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           // Save changes to temporary variables
//                           tempSelectedImage = selectedImage;
//                           tempSelectedAvatarIndex = selectedAvatarIndex;
//                           setState(() {
//                             // selectedAvatarIndex = avatarIndex;
//                             _isEditProfile = true;
//                             _isMyProfile = false;
//                           });
//                           Navigator.pop(context);
//                         },
//                         style: kElevatedButtonPrimaryBG,
//                         child: const Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Submit',
//                             style: kFont12,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           Navigator.pop(context);
//                           setState(() {
//                             //selectedImage = tempSelectedImage;
//                             selectedAvatarIndex = tempSelectedAvatarIndex;
//                           });
//                         },
//                         style: kElevatedButtonWhiteOpacityBG,
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             'Cancel',
//                             style: kFont12.copyWith(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
//
