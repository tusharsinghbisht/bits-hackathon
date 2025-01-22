import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';
import 'hospitals_screen.dart';
import 'medications_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../models/article.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    HomeScreenContent(),
     const ReportsScreen(),
     const HospitalsScreenContent(),
     const MedicationsScreenContent(),
     const ProfileScreenContent(),
  ];

  void _onProfileTap() {
    setState(() {
      _selectedIndex = 4; // Index of the ProfileScreenContent
    });
    _bottomNavigationKey.currentState?.setPage(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color: const Color(0xFFB0C4DE), // Light blue background similar to your image
        buttonBackgroundColor: Colors.blue, // Highlight color for selected icon
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.folder, size: 30, color: Colors.white),
          Icon(Icons.medical_services_rounded, size: 30, color: Colors.white),
          Icon(Icons.medication_rounded, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  HomeScreenContent({super.key});

  final List<Article> articles = [
    Article(
      title: "India's 100-Day Tuberculosis (TB) Elimination Campaign: A Step Towards a TB-Free Nation",
      content: '''Tuberculosis (TB) has long been a public health challenge in India, accounting for a significant portion of global TB cases. To address this issue, the Indian government has launched an ambitious 100-Day Tuberculosis Elimination Campaign, aiming to accelerate progress towards the goal of eliminating TB by 2030. This campaign, rolled out across the country, is a collaborative effort involving multiple stakeholders and innovative strategies to combat this deadly disease.
Key Objectives of the Campaign
Enhanced Detection and Diagnosis: The campaign focuses on proactive identification of TB cases, especially in high-risk populations such as individuals with malnutrition, diabetes, and HIV/AIDS. Mobile health units and community health workers play a pivotal role in screening and diagnosing cases in underserved and remote areas.
Intensive Treatment Support: Patients diagnosed with TB are provided with financial assistance under the Nikshay Poshan Yojana, which allocates ₹500 per month to support nutritional needs. Adherence to treatment is emphasized through regular follow-ups and counseling sessions.
Community Engagement: Local governance bodies and non-governmental organizations are actively involved in raising awareness about TB and reducing stigma. Initiatives like the Nikshay Mitra Scheme encourage communities to "adopt" TB patients, providing them with comprehensive support.
Leveraging Technology: The campaign uses technology-driven tools, such as mobile apps and electronic health records, to monitor patient progress and ensure timely interventions. Additionally, public awareness campaigns utilize digital platforms to disseminate information about TB prevention and treatment.
Special Focus Areas
The campaign prioritizes regions with the highest TB burden, including states like Uttar Pradesh, Punjab, and Rajasthan. These areas see intensified efforts, such as door-to-door screening programs and targeted interventions for vulnerable groups.
Innovative Strategies
Mobile Health Clinics: Equipped with diagnostic tools, these clinics reach remote areas where access to healthcare is limited.
Awareness Drives: Creative outreach methods, including health fairs and interactive sessions, educate the public about TB symptoms, prevention, and treatment.
Rigorous Facility Audits: TB treatment centers undergo evaluations to improve service delivery and address delays in care.
Why This Campaign is Critical?
TB is often detected late due to stigma and lack of awareness, leading to increased transmission and mortality. The 100-day campaign aims to break this cycle by ensuring early detection and treatment adherence. With the added impact of the COVID-19 pandemic disrupting TB care, this initiative comes at a crucial time to rebuild and strengthen the healthcare system’s response to TB.
Challenges Ahead
Despite its robust design, the campaign faces challenges such as:
Overcoming the stigma associated with TB.
Ensuring consistent financial and logistic support.
Addressing the social determinants of health that contribute to TB, such as poverty and malnutrition.
Vision for a TB-Free India
India’s 100-Day Tuberculosis Elimination Campaign is a significant step forward in the fight against TB. By integrating community efforts, technological advancements, and government initiatives, the campaign strives to create a future where TB is no longer a public health threat. This comprehensive approach serves as a blueprint for other nations aiming to tackle infectious diseases.
The success of this campaign will depend on sustained efforts, collective action, and unwavering commitment to the health and well-being of every citizen. Together, we can achieve a TB-free India by 2030.
''',
      image: 'assets/images/image13.png',
      icon: 'assets/icons/image20.png',
    ),
    Article(
      title: "Jupiter Foundation's 'My Organ Project': Promoting the Gift of Life",
      content: '''Organ donation has the power to save countless lives, yet a significant gap exists between the need for organs and their availability. In a bold and compassionate effort to bridge this gap, the Jupiter Foundation has launched the 'My Organ Project', a pioneering initiative aimed at raising awareness and encouraging organ donation across India.
Objectives of 'My Organ Project'
The project aspires to create a society where organ donation is normalized and embraced as an act of altruism. Its primary objectives include:
Increasing Awareness: Educating people about the importance of organ donation and dispelling myths and misconceptions.
Building a Strong Support System: Creating a robust network to facilitate the organ donation process.
Encouraging Ethical Practices: Ensuring transparency and fairness in organ donation and transplantation.
Core Strategies of the Initiative
Community Engagement Programs: The project organizes workshops, seminars, and interactive sessions in schools, corporates, and housing societies to educate people about organ donation. These events are designed to demystify the process and inspire more individuals to pledge their organs.
Digital Campaigns: Leveraging the power of social media, 'My Organ Project' runs targeted campaigns to reach a wider audience. Compelling stories of organ recipients and donors are shared to highlight the life-changing impact of donation.
Collaboration with Healthcare Institutions: Partnerships with hospitals and transplant centers ensure a streamlined process for organ retrieval and transplantation. The initiative also promotes the use of registries for potential donors.
Youth-Centric Drives: Recognizing the influence of the younger generation, the project engages with students through awareness drives in colleges and universities. These activities aim to foster a culture of giving and social responsibility.
Challenges in Promoting Organ Donation
Cultural and Religious Beliefs: Misconceptions about organ donation being against certain cultural or religious practices often deter individuals from pledging their organs.
Lack of Awareness: Many people are unaware of the procedure, eligibility criteria, and its life-saving potential.
Emotional Barriers: Families of potential donors often hesitate to give consent due to emotional and psychological factors.
Achievements and Impact
Since its inception, 'My Organ Project' has:
Conducted over 1,000 awareness sessions, impacting more than 50,000 individuals.
Increased organ donor registration by 20% in targeted regions.
Facilitated multiple successful transplants through its partnerships with healthcare providers.
How to Get Involved
Pledge Your Organs: Sign up as an organ donor through the official portal of 'My Organ Project'.
Spread the Word: Share information about organ donation within your community and on social media.
Volunteer: Join the initiative as a volunteer to support awareness and outreach programs.
Support Financially: Contribute to the project to help sustain its activities and expand its reach.
The Road Ahead
Jupiter Foundation's 'My Organ Project' envisions a future where no life is lost due to the lack of an organ. By addressing barriers, fostering partnerships, and spreading awareness, the initiative aims to create a sustainable culture of organ donation in India. Every pledge brings us one step closer to a healthier, more compassionate society.
Together, let’s make organ donation the ultimate gift of life.
''',
      image: 'assets/images/image2.png',
      icon: 'assets/icons/icon2.png',
    ),
    Article(
      title: "Healthy India, Happy India:Building a Nation Focused on Preventive Healthcare, Wellness & Holistic Growth",
      content: '''A nation’s true wealth lies in the health and happiness of its people. With the guiding principle of "Healthy India, Happy India," the aim is to cultivate a society that prioritizes physical well-being, mental health, and sustainable living. This vision aligns with India’s commitment to building a healthier future for its citizens, fostering not only economic prosperity but also a harmonious and inclusive society.
The 'Healthy India, Happy India' Campaign
Launched as a joint initiative by The Hindu and Naruvi Hospitals, Vellore, the "Healthy India, Happy India" campaign emphasizes the importance of preventive healthcare and wellness. Inaugurated by r in December 2024, the campaign aims to build public awareness about staying healthy and addressing lifestyle-related health issues before they escalate.
Mr. Udhayanidhi appreciated the collaboration between The Hindu Group and Naruvi Hospitals, stating that such partnerships play a vital role in taking health-related messages to the masses. During the inauguration, N. Ram, Director of The Hindu Group, highlighted Tamil Nadu’s leadership in healthcare initiatives, and G.V. Sampath, Founder and Chairman of Naruvi Hospitals, spoke about the project’s origins and its focus on community wellness.
Key Pillars of Healthy India, Happy India
Universal Healthcare Access: India has taken significant strides in ensuring healthcare for all, especially through the Ayushman Bharat Pradhan Mantri Jan Arogya Yojana (PM-JAY), the world’s largest government-funded healthcare program. By providing free access to healthcare services for economically weaker sections, the program reduces financial barriers and promotes equitable health outcomes.
Nutrition for All: Malnutrition continues to be a challenge, particularly among children and women. Initiatives like the Poshan Abhiyaan (National Nutrition Mission) and the Mid-Day Meal Scheme in schools aim to eradicate malnutrition and promote awareness about balanced diets. These efforts focus on ensuring every Indian has access to essential nutrients for growth and development.
Fit India Movement: Launched in 2019, the Fit India Movement encourages individuals to incorporate physical activity into their daily lives. From organizing fitness challenges to promoting yoga and sports, this initiative inspires people to embrace a healthier lifestyle, reducing the burden of non-communicable diseases.
Mental Health Awareness: Recognizing mental health as an integral part of overall well-being, India has introduced policies and platforms to support mental health. The National Mental Health Programme (NMHP) and helplines like Kiran offer counseling and support to those in need, breaking the stigma surrounding mental health issues.
Disease Prevention and Vaccination: With an emphasis on preventive care, India has rolled out extensive vaccination drives, such as the Mission Indradhanush, to protect children and mothers from preventable diseases. Additionally, national campaigns like the 100-Day TB Elimination Drive demonstrate a proactive approach to tackling chronic diseases.
Clean Environment, Healthy Lives: The environment directly impacts public health. The Swachh Bharat Abhiyan (Clean India Mission) not only aims to eliminate open defecation but also fosters hygiene and cleanliness. Efforts to combat pollution and increase green cover further contribute to a healthier living environment.
The Role of Technology
The integration of technology into healthcare and wellness has been transformative. From telemedicine platforms that extend healthcare services to rural areas to fitness apps promoting active lifestyles, digital tools have become enablers of health and happiness. The National Digital Health Mission (NDHM) aims to create a unified digital health ecosystem, empowering individuals to manage their health records and access services seamlessly.
Challenges and the Way Forward
While the vision of "Healthy India, Happy India" is ambitious, it is not without challenges. Key barriers include:
Healthcare Disparities: Rural and remote areas often lack access to quality healthcare facilities.
Lifestyle Diseases: Rising cases of diabetes, hypertension, and obesity call for widespread lifestyle changes.
Awareness Gaps: A significant portion of the population remains unaware of preventive healthcare practices.
To overcome these challenges, a collaborative approach involving government, private sectors, and communities is essential. Policies must focus on:
Strengthening primary healthcare systems.
Promoting health literacy through educational campaigns.
Encouraging public-private partnerships for innovative solutions.
Conclusion
"Healthy India, Happy India" is more than just a slogan; it is a call to action for individuals, communities, and policymakers to work together towards a common goal. By prioritizing health and happiness, India can unlock its true potential, fostering a society that is not only prosperous but also content and resilient. A healthier India is indeed a happier India, and this vision requires every citizen’s active participation to become a reality.

''',
      image: 'assets/images/image3.png',
      icon: 'assets/icons/icon3.png',
    ),
    Article(
      title: "Mental Health and Resilience in the Workplace: A Call for Empathy and Action",
      content: '''The workplace, often seen as a second home, plays a critical role in shaping individuals’ mental well-being. Yet, recent incidents, such as the controversial termination of employees by Yes Madam for citing stress as a reason for underperformance, highlight a growing disconnect between corporate expectations and mental health awareness. This article examines the implications of such actions and advocates for a shift toward a more empathetic and inclusive workplace culture.
The Yes Madam Incident: A Reflection of Workplace Realities
Yes Madam, a prominent home service platform, faced public scrutiny after reportedly firing employees who cited stress as the reason for their inability to meet performance targets. While the company’s rationale may have been rooted in maintaining productivity, the decision raises critical questions about the role of organizations in supporting their workforce during times of mental distress.
This incident is not isolated. It reflects a broader trend where mental health challenges are often misunderstood or stigmatized in professional settings. Such actions can discourage employees from seeking help or being open about their struggles, leading to a toxic cycle of unaddressed issues and declining morale.
The Cost of Ignoring Mental Health
Employee Well-being: Neglecting mental health in the workplace can lead to burnout, anxiety, and depression. These conditions not only affect employees’ personal lives but also impair their professional performance.
Organizational Impact: A workforce under mental duress often experiences reduced productivity, higher absenteeism, and increased turnover rates. According to a report by the World Health Organization (WHO), depression and anxiety cost the global economy an estimated \$1 trillion per year in lost productivity.
Legal and Reputational Risks: Organizations that fail to address mental health issues risk facing legal challenges and reputational damage. In an era of social media transparency, actions perceived as insensitive can rapidly escalate into public relations crises.
Building a Mental Health-Friendly Workplace
Policy Frameworks: Organizations must establish clear policies that prioritize mental health. This includes offering flexible working arrangements, mental health days, and access to counseling services.
Leadership Training: Managers and leaders play a pivotal role in shaping workplace culture. Providing them with training on mental health awareness can help create an environment where employees feel supported.
Open Communication: Encouraging open dialogues about mental health can break the stigma and foster a sense of community. Platforms for anonymous feedback can also help employees voice concerns without fear of judgment.
Preventive Measures: Regular workshops on stress management, mindfulness, and work-life balance can equip employees with tools to navigate challenges effectively.
A Shared Responsibility
Mental health is a shared responsibility that requires collective action from employees, employers, and policymakers. The government’s initiatives, such as the National Mental Health Programme (NMHP) and workplace guidelines issued by labor authorities, provide a foundation. However, the onus lies equally on organizations to implement these frameworks and go beyond compliance to build truly inclusive workplaces.
Conclusion
The Yes Madam incident serves as a wake-up call for businesses to reassess their approach to mental health. By fostering a culture of empathy and support, organizations can not only enhance employee well-being but also unlock their full potential. In the end, a mentally resilient workforce is not just a moral imperative but a strategic advantage in today’s competitive landscape.
Mental health matters. It’s time for workplaces to step up and lead the change.

''',
      image: 'assets/images/image4.png',
      icon: 'assets/icons/icon4.png',
    ),
    
    // Add more articles...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          const SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 80, // Reduced height
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.0, // Prevents text scaling
            titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            title: Row(
              children: [
                Text(
                  'Latest in Health',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

          // Articles List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = articles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () => _showArticleDetail(context, article),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.asset(
                                article.image,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Image.asset(
                                          article.icon,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          article.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF07569b),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    article.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: articles.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showArticleDetail(BuildContext context, Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(article: article),
      ),
    );
  }
}