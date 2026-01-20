import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../widgets/subtitle_text.dart';

class AddProductScreen extends StatefulWidget {
  static const routName = "/AddProductScreen";
  final ProductModel? productModel;

  const AddProductScreen({super.key, this.productModel});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _categoryController;
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Electronics';
  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Books',
    'Cosmetics',
    'Shoes',
    'Watches',
    'Mobiles',
    'PC',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.productModel?.productTitle ?? '',
    );
    _priceController = TextEditingController(
      text: widget.productModel?.productPrice ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.productModel?.productDescription ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.productModel?.quantity.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.productModel?.productCategory ?? '',
    );
    if (widget.productModel != null) {
      _selectedCategory = widget.productModel!.productCategory;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageName = image.name;
      });
    }
  }

  Future<String?> uploadImageToCloudinary(
    Uint8List imageBytes,
    String fileName,
  ) async {
    const cloudName = 'ddwfkeess';
    const uploadPreset = 'ecommerce';
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
      );
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final data = jsonDecode(respStr);
        return data['secure_url'];
      }
      return null;
    } catch (e) {
      debugPrint('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImageBytes == null && widget.productModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);

      String imageUrl = widget.productModel?.productImage ?? '';
      if (_selectedImageBytes != null) {
        imageUrl = await uploadImageToCloudinary(
              _selectedImageBytes!,
              _selectedImageName ?? 'product_image.jpg',
            ) ??
            '';
        if (imageUrl.isEmpty) {
          throw Exception('Failed to upload image to Cloudinary');
        }
      }

      final product = ProductModel(
        productId: widget.productModel?.productId ?? '',
        productTitle: _titleController.text.trim(),
        productPrice: _priceController.text.trim(),
        productCategory: _selectedCategory,
        productDescription: _descriptionController.text.trim(),
        productImage: imageUrl,
        createdAt: widget.productModel?.createdAt ?? Timestamp.now(),
        rating: widget.productModel?.rating ?? 0.0,
        quantity: int.parse(_quantityController.text.trim()),
        productImages: widget.productModel?.productImages ?? [],
      );

      String? error;
      if (widget.productModel == null) {
        error = await productsProvider.addProduct(product);
      } else {
        error = await productsProvider.updateProduct(
          widget.productModel!.productId,
          product,
        );
      }

      if (mounted) {
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.productModel == null
                    ? 'Product added successfully'
                    : 'Product updated successfully',
              ),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productModel == null ? 'Add Product' : 'Edit Product',
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _selectedImageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _selectedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : widget.productModel?.productImage != null &&
                                    widget.productModel!.productImage.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      widget.productModel!.productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(IconlyLight.image, size: 48),
                                        SizedBox(height: 8),
                                        SubtitleTextWidget(
                                          label: 'Tap to add image',
                                        ),
                                      ],
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SubtitleTextWidget(label: 'Product Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter product title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const SubtitleTextWidget(label: 'Product Price'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter product price',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product price is required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const SubtitleTextWidget(label: 'Product Category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const SubtitleTextWidget(label: 'Product Quantity'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter product quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Quantity is required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const SubtitleTextWidget(label: 'Product Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter product description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        if (value.length < 20) {
                          return 'Description must be at least 20 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: Icon(
                          widget.productModel == null
                              ? Icons.add_circle_outline
                              : Icons.edit,
                        ),
                        label: Text(
                          widget.productModel == null
                              ? 'Add Product'
                              : 'Update Product',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

