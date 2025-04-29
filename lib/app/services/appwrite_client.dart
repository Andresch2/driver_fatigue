import 'package:appwrite/appwrite.dart';

import '../constants/constants.dart';

final Client client = Client()
  ..setEndpoint(AppwriteConstants.endpoint)
  ..setProject(AppwriteConstants.projectId);
