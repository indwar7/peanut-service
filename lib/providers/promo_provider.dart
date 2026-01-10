import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/promo.dart';

class PromoProvider with ChangeNotifier {
  List _promos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List get promos => _promos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future fetchPromos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final soapBody = '''

  
    
      en
    
  
''';

      final response = await http.post(
        Uri.parse(
          'https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc',
        ),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': 'http://tempuri.org/ICabinetMicroService/GetCCPromo',
        },
        body: soapBody,
      );

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final promoElements = document.findAllElements('Promo');

        _promos = promoElements
            .map((element) => Promo.fromXml(element))
            .toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load promos';
      _isLoading = false;
      notifyListeners();
    }
  }
}
