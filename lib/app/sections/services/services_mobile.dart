part of 'services.dart';

class ServiceMobile extends StatelessWidget {
  const ServiceMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        const CustomSectionHeading(text: '\nWhat I can do?'),
        Space.y(3.w)!,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomSectionSubHeading(text: servicesSubHeading),
        ),
        Space.y(5.w)!,
        CarouselSlider.builder(
          itemCount: servicesUtils.length,
          itemBuilder: (BuildContext context, int itemIndex, int i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: _ServiceCard(
              service: servicesUtils[i],
              cardWidth: Responsive.isTablet(context) ? 350 : 290,
              cardHeight: 360,
            ).animate().fadeIn(duration: 400.ms),
          ),
          options: CarouselOptions(
            viewportFraction: Responsive.isTablet(context) ? 0.5 : 0.82,
            height: 390,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            enableInfiniteScroll: false,
          ),
        )
      ],
    );
  }
}
