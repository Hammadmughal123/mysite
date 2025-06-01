class ServicesUtils {
  final String name;
  final String icon;
  final List<String> tool;
  final String description;

  ServicesUtils(
      {required this.name,
      required this.icon,
      required this.description,
      required this.tool});
}

List<ServicesUtils> servicesUtils = [
  ServicesUtils(
    name: 'Android App Development',
    icon: 'assets/icons/android.svg',
    description:
        "Are you interested in the great Mobile app? Let's make it a reality.",
    tool: [
      'Flutter',
    ],
  ),
  ServicesUtils(
    name: 'iOS App Development',
    icon: 'assets/icons/apple.svg',
    description:
        "Are you interested in the great Mobile app? Let's make it a reality.",
    tool: [
      'Flutter',
    ],
  ),
  ServicesUtils(
    name: 'Backend Integration & Firebase',
    icon:
        'assets/imgs/cloud.png', // Make sure you have this icon or any cloud-related icon.
    description:
        "Integrate scalable backends using Firebase, Supabase, Node.js, or Laravel for APIs, auth, storage, and notifications",
    tool: ['Firebase', 'Supabase', 'REST API'],
  ),
  ServicesUtils(
    name: 'Web Development',
    icon: 'assets/icons/website.svg',
    description:
        "Do you have an idea for your next great website? Let's make it a reality.",
    tool: [
      'Flutter',
    ],
  ),
];
