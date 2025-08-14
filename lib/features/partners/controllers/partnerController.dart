import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gslibrarydashboard/exceptions/appException.dart';
import 'package:gslibrarydashboard/features/partners/models/partner.dart';
import 'package:gslibrarydashboard/features/partners/models/pagination_info.dart';
import 'package:gslibrarydashboard/features/partners/services/partnerService.dart';
import 'package:gslibrarydashboard/home/controller/homeController.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class PartnerController extends GetxController with StateMixin<List<Partner>> {
  // Contrôleurs de texte pour les formulaires
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController maxUsersController = TextEditingController();
  TextEditingController commissionController = TextEditingController();
  TextEditingController webhookUrlController = TextEditingController();

  // Contrôleurs pour les informations de contact
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactPhoneController = TextEditingController();

  // Variables réactives
  RxBool isLoading = false.obs;
  RxList<Partner> partnerList = <Partner>[].obs;
  RxString selectedStatus = 'active'.obs;
  RxString selectedFilterStatus = ''.obs;

  final HomeController homeController = Get.find();

  // Paramètres de pagination
  RxInt currentPage = 1.obs;
  RxInt pageSize = 10.obs;
  RxInt totalItems = 0.obs;
  RxInt totalPages = 0.obs;
  
  // Cache pour stocker les données de chaque page
  Map<int, List<Partner>> pageCache = <int, List<Partner>>{};

  // Paramètres du partenaire
  Partner? selectedPartner;
  RxList<String> allowedCategories = <String>[].obs;
  RxList<String> allowedBooks = <String>[].obs;

  // Paramètres par défaut
  PartnerSettings defaultSettings = PartnerSettings(
    canPurchase: true.obs,
    canViewCategories: true.obs,
    canViewBooks: true.obs,
    canViewPurchases: true.obs,
  );

  final PartnerService partnerService = Get.put(PartnerService());

  @override
  void onInit() {
    super.onInit();
    fetchPartners();
  }

  // Récupérer la liste des partenaires
  Future<void> fetchPartners({bool refresh = false}) async {
    if (refresh) {
      partnerList.clear();
      pageCache.clear(); // Vider le cache lors d'un refresh
    }

    // Vérifier si les données de la page actuelle sont déjà en cache
    if (pageCache.containsKey(currentPage.value)) {
      partnerList.value = pageCache[currentPage.value]!;
      change(partnerList, status: RxStatus.success());
      return;
    }

    change(null, status: RxStatus.loading());
    try {
      Map<String, dynamic> result = await partnerService.getPartners(
        page: currentPage.value,
        pageSize: pageSize.value,
        status: selectedFilterStatus.value.isEmpty
            ? null
            : selectedFilterStatus.value,
      );

      List<Partner> partners = result['partners'];
      PaginationInfo pagination = result['pagination'];

      // Mettre à jour les informations de pagination
      totalItems.value = pagination.total;
      totalPages.value = pagination.numOfPages;

      // Stocker les données dans le cache
      pageCache[currentPage.value] = partners;
      
      // Afficher les données de la page actuelle
      partnerList.value = partners;

      if (partnerList.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(partnerList, status: RxStatus.success());
      }
    } on AppException catch (e) {
      change(null, status: RxStatus.error(e.message));
    }
  }

  // Changer de page
  Future<void> changePage(int page) async {
    if (page < 1 || page > totalPages.value) return;
    
    currentPage.value = page;
    await fetchPartners(refresh: false);
  }

  // Changer le nombre d'éléments par page
  Future<void> changePageSize(int size) async {
    pageSize.value = size;
    currentPage.value = 1; // Retour à la première page
    pageCache.clear(); // Vider le cache car la taille de page a changé
    await fetchPartners(refresh: false);
  }

  // Filtrer par statut
  void filterByStatus(String status) {
    selectedFilterStatus.value = status;
    pageCache.clear(); // Vider le cache car le filtre a changé
    fetchPartners(refresh: true);
  }

  // Créer un nouveau partenaire
  Future<void> createPartner() async {
    if (!_validateForm()) return;

    isLoading.value = true;
    try {
      ContactPerson contactPerson = ContactPerson(
        name: contactNameController.text.trim(),
        phone: contactPhoneController.text.trim(),
      );

      Partner newPartner = await partnerService.createPartner(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        startDate: startDateController.text.trim(),
        endDate: endDateController.text.trim(),
        maxUsers: int.tryParse(maxUsersController.text.trim()),
        allowedCategories:
            allowedCategories.isNotEmpty ? allowedCategories : null,
        allowedBooks: allowedBooks.isNotEmpty ? allowedBooks : null,
        commission: double.tryParse(commissionController.text.trim()),
        contactPerson: contactPerson,
        webhookUrl: webhookUrlController.text.trim().isEmpty
            ? null
            : webhookUrlController.text.trim(),
        settings: defaultSettings,
      );

      partnerList.add(newPartner);
      Fluttertoast.showToast(
        msg: "Partenaire créé avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
      clearForm();
      Get.back(); // Fermer le modal/écran de création
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Mettre à jour un partenaire
  Future<void> updatePartner() async {
    if (selectedPartner == null || !_validateForm()) return;

    isLoading.value = true;
    try {
      ContactPerson contactPerson = ContactPerson(
        name: contactNameController.text.trim(),
        phone: contactPhoneController.text.trim(),
      );

      Partner updatedPartner = await partnerService.updatePartner(
        partnerId: selectedPartner!.sId!,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
        startDate: startDateController.text.trim(),
        endDate: endDateController.text.trim(),
        maxUsers: int.tryParse(maxUsersController.text.trim()),
        allowedCategories:
            allowedCategories.isNotEmpty ? allowedCategories : null,
        allowedBooks: allowedBooks.isNotEmpty ? allowedBooks : null,
        commission: double.tryParse(commissionController.text.trim()),
        contactPerson: contactPerson,
        webhookUrl: webhookUrlController.text.trim().isEmpty
            ? null
            : webhookUrlController.text.trim(),
        settings: defaultSettings,
      );

      // Mettre à jour dans la liste
      int index = partnerList.indexWhere((p) => p.sId == selectedPartner!.sId);
      if (index != -1) {
        partnerList[index] = updatedPartner;
      }

      Fluttertoast.showToast(
        msg: "Partenaire mis à jour avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
      clearForm();
      Get.back();
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Désactiver un partenaire
  Future<void> deactivatePartner(Partner partner) async {
    isLoading.value = true;
    try {
      Partner updatedPartner = await partnerService.deactivatePartner(
        partnerId: partner.sId!,
        status: 'inactive',
      );

      // Mettre à jour dans la liste
      int index = partnerList.indexWhere((p) => p.sId == partner.sId);
      if (index != -1) {
        partnerList[index] = updatedPartner;
      }

      Fluttertoast.showToast(
        msg: "Partenaire désactivé avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Activer un partenaire
  Future<void> activatePartner(Partner partner) async {
    isLoading.value = true;
    try {
      Partner updatedPartner = await partnerService.deactivatePartner(
        partnerId: partner.sId!,
        status: 'active',
      );

      // Mettre à jour dans la liste
      int index = partnerList.indexWhere((p) => p.sId == partner.sId);
      if (index != -1) {
        partnerList[index] = updatedPartner;
      }

      Fluttertoast.showToast(
        msg: "Partenaire activé avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Supprimer un partenaire
  Future<void> deletePartner(Partner partner) async {
    isLoading.value = true;
    try {
      await partnerService.deletePartner(partnerId: partner.sId!);

      // Supprimer de la liste
      partnerList.removeWhere((p) => p.sId == partner.sId);

      Fluttertoast.showToast(
        msg: "Partenaire supprimé avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Régénérer l'API key
  Future<void> regenerateApiKey(Partner partner) async {
    isLoading.value = true;
    try {
      Partner updatedPartner = await partnerService.regenerateApiKey(
        partnerId: partner.sId!,
      );

      // Mettre à jour dans la liste
      int index = partnerList.indexWhere((p) => p.sId == partner.sId);
      if (index != -1) {
        partnerList[index] = updatedPartner;
      }

      Fluttertoast.showToast(
        msg: "Clé API régénérée avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Mettre à jour le solde
  Future<void> updateBalance(Partner partner, double newBalance) async {
    isLoading.value = true;
    try {
      Partner updatedPartner = await partnerService.updatePartnerBalance(
        partnerId: partner.sId!,
        balance: newBalance,
      );

      // Mettre à jour dans la liste
      int index = partnerList.indexWhere((p) => p.sId == partner.sId);
      if (index != -1) {
        partnerList[index] = updatedPartner;
      }

      Fluttertoast.showToast(
        msg: "Solde mis à jour avec succès",
        backgroundColor: Colors.green,
      );
      isLoading.value = false;
    } on AppException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        backgroundColor: Colors.red,
      );
      isLoading.value = false;
    }
  }

  // Remplir le formulaire pour l'édition
  void setPartnerForEdit(Partner partner) {
    selectedPartner = partner;
    nameController.text = partner.name ?? '';
    emailController.text = partner.email ?? '';
    descriptionController.text = partner.description ?? '';
    startDateController.text = partner.startDate ?? '';
    endDateController.text = partner.endDate ?? '';
    maxUsersController.text = partner.maxUsers?.toString() ?? '';
    commissionController.text = partner.commission?.toString() ?? '';
    webhookUrlController.text = partner.webhookUrl ?? '';

    // Informations de contact
    if (partner.contactPerson != null) {
      contactNameController.text = partner.contactPerson!.name ?? '';
      contactPhoneController.text = partner.contactPerson!.phone ?? '';
    }

    // Paramètres
    if (partner.settings != null) {
      defaultSettings = partner.settings!;
    }

    // Listes autorisées
    allowedCategories.assignAll(partner.allowedCategories ?? []);
    allowedBooks.assignAll(partner.allowedBooks ?? []);

    homeController.selectedItem!.value = AdminMenuItem(
      title: 'ajouter un partenaire',
      icon: Icons.add,
      route: '/partners/add',
    );
    selectedPartner=partner;
  }

  // Ajouter une catégorie autorisée
  void addAllowedCategory(String categoryId) {
    if (!allowedCategories.contains(categoryId)) {
      allowedCategories.add(categoryId);
    }
  }

  // Supprimer une catégorie autorisée
  void removeAllowedCategory(String categoryId) {
    allowedCategories.remove(categoryId);
  }

  // Ajouter un livre autorisé
  void addAllowedBook(String bookId) {
    if (!allowedBooks.contains(bookId)) {
      allowedBooks.add(bookId);
    }
  }

  // Supprimer un livre autorisé
  void removeAllowedBook(String bookId) {
    allowedBooks.remove(bookId);
  }

  // Valider le formulaire
  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Le nom du partenaire est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (emailController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "L'email du partenaire est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (startDateController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "La date de début est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (endDateController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "La date de fin est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (contactNameController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Le nom du contact est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    if (contactPhoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Le téléphone du contact est obligatoire",
        backgroundColor: Colors.red,
      );
      return false;
    }

    return true;
  }

  // Effacer le formulaire
  void clearForm() {
    selectedPartner = null;
    nameController.clear();
    emailController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    maxUsersController.clear();
    commissionController.clear();
    webhookUrlController.clear();
    contactNameController.clear();
    contactPhoneController.clear();

    allowedCategories.clear();
    allowedBooks.clear();

    defaultSettings = PartnerSettings(
      canPurchase: true.obs,
      canViewCategories: true.obs,
      canViewBooks: true.obs,
      canViewPurchases: true.obs,
    );
  }

  // Obtenir le statut en français
  String getStatusInFrench(String status) {
    switch (status) {
      case 'active':
        return 'Actif';
      case 'inactive':
        return 'Inactif';
      case 'suspended':
        return 'Suspendu';
      default:
        return status;
    }
  }

  // Obtenir la couleur du statut
  Color getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Copier l'API key dans le presse-papiers
  void copyApiKey(Partner partner) {
    if (partner.apiKey != null && partner.apiKey!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: partner.apiKey!));
      Fluttertoast.showToast(
        msg: "Clé API copiée dans le presse-papiers",
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Aucune clé API disponible",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    maxUsersController.dispose();
    commissionController.dispose();
    webhookUrlController.dispose();
    contactNameController.dispose();
    contactPhoneController.dispose();
    super.onClose();
  }
}
