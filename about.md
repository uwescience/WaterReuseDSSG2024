---
layout: page
title: Meet the Team
---

## The Team
<div style="display: flex; flex-wrap: wrap; justify-content: space-around; text-align: center;">

  <div class="team-member" style="width: 25%; padding: 10px;">
    <p><strong>Project Lead</strong></p>
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Miriam.png" alt="Miriam Hacker" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('miriam-bio')">
    <p style="margin: 0;">Miriam Hacker</p>
    <div id="miriam-bio" class="bio-popup" style="display: none;">
      <p>Miriam Hacker bio goes here.</p>
    </div>
  </div>

  <div class="team-member" style="width: 25%; padding: 10px;">
    <p><strong>Project Advisor</strong></p>
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Carolyn.jpg" alt="Carolyn Hayek" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('carolyn-bio')">
    <p style="margin: 0;">Carolyn Hayek</p>
    <div id="carolyn-bio" class="bio-popup" style="display: none;">
      <p>Carolyn Hayek bio goes here.</p>
    </div>
  </div>

  <div class="team-member" style="width: 25%; padding: 10px;">
    <p><strong>Data Scientist</strong></p>
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Curtis.jpg" alt="Curtis Atkisson" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('curtis-bio')">
    <p style="margin: 0;">Curtis Atkisson</p>
    <div id="curtis-bio" class="bio-popup" style="display: none;">
      <p>Curtis Atkisson bio goes here.</p>
    </div>
  </div>

</div>

<p><strong>DSSG Fellows:</strong></p>
<div style="display: flex; flex-wrap: wrap; justify-content: center;">
  <div class="team-member" style="width: 25%; text-align: center; padding: 10px;">
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Jihyeon.jpg" alt="Jihyeon Bae" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('jihyeon-bio')">
    <p style="margin: 0;">Jihyeon Bae</p>
    <div id="jihyeon-bio" class="bio-popup" style="display: none;">
      <p>**Jihyeon Bae, Student Fellow**
Ph.D. Candidate
Political Science, University of Washington

Jihyeon Bae is a PhD candidate in the Political Science Department at the University of Washington. She is interested in comparing design choices around international organizations and how they influence cooperation among states. She is also passionate about applying NLP models to explore how rhetoric changes in international forums like the United Nations General Assembly. During the UW DSSG program, she will work on a project assessing water reuse patterns, based on substantive knowledge in actor-based institutional design. Born and raised in South Korea, she received her B.A. in International Studies from Kyung Hee University in 2019, with additional training from the Applied Mathematics Department.</p>
    </div>
  </div>
  <div class="team-member" style="width: 25%; text-align: center; padding: 10px;">
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Nora.jpg" alt="Nora Povejsil" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('nora-bio')">
    <p style="margin: 0;">Nora Povejsil</p>
    <div id="nora-bio" class="bio-popup" style="display: none;">
      <p> **Nora Povejsil, Student Fellow**
Master’s Student
Information and Data Science, University of California, Berkeley

Nora Povejsil is a Master’s student studying Information and Data Science at the University of California, Berkeley. Nora’s dedication to using her technical skills for good was recognized through the Jack Larson “Data for Good” Fellowship award she received during the 2023-2024 academic year from her university.
Her educational background includes a double major Bachelor’s degree in Data Science and Public Health from UC Berkeley. During that time, she served as an Undergraduate Student Instructor for a class on the U.S. healthcare system. Driven by a desire to address public health inequities, Nora sought out experiences to advocate for underserved communities in women’s healthcare as a Medical Assistant for the Midwifery unit at the Hennepin County Medical Center in Minneapolis and as a volunteer at the Daytime Women’s Drop-In Center in Berkeley.
Nora also has a strong passion for environmental work. She applied her data science skills as an Undergraduate Research Assistant for the Power Lab, an integrative biology/ecology lab, creating machine learning algorithms to identify fish species and track ecological patterns and migration trends in Northern California.</p>
    </div>
  </div>
  <div class="team-member" style="width: 25%; text-align: center; padding: 10px;">
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Mbye.jpg" alt="Mbye Sallah" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('mbye-bio')">
    <p style="margin: 0;">Mbye Sallah</p>
    <div id="mbye-bio" class="bio-popup" style="display: none;">
      <p>**Mbye Sallah, Student Fellow**
Master’s Student
Applied Economics, Ohio University

Mbye is currently pursuing a master’s degree in applied economics at Ohio University. He also holds dual bachelor’s degrees in Economics and Finance and Banking from Suleyman Demirel University. Being from a low-income country, The Gambia, his research interest focuses on development economics, specifically financial development, and household welfare. Realizing the potential of data science in unraveling complex societal problems and motivated by his commitment to bridging the gap between economic theory and practical solutions, he is eager to join the DSSG fellowship. With a background in economics, he hopes to enhance his data science skills, which he can utilize to understand and provide practical solutions to societal issues.
</p>
    </div>
  </div>
  <div class="team-member" style="width: 25%; text-align: center; padding: 10px;">
    <img src="{{ site.url }}{{ site.baseurl }}/assets/img/Daniel.jpg" alt="Daniel Vogler" style="width:200px; height:200px; object-fit: cover;" onclick="showBio('daniel-bio')">
    <p style="margin: 0;">Daniel Vogler</p>
    <div id="daniel-bio" class="bio-popup" style="display: none;">
      <p>**Daniel Vogler, Student Fellow**
Master’s Student
Data Science, University of Washington

I am currently pursuing a Master’s degree in Data Science at the University of Washington. Before graduate school I worked as a management consultant, primarily supporting clients in healthcare and retail. I graduated with a B.A. from Princeton University in 2021. I am deeply interested in the intersection between data science, machine learning, and energy, especially in data-driven approaches to energy policy. I am excited to participate in the DSSG program for the opportunity to further explore how data science can help communities pursue sustainable development as part of the Water Reuse project.</p>
    </div>
  </div>
</div>

<script>
function showBio(id) {
  var bio = document.getElementById(id);
  if (bio.style.display === "none") {
    bio.style.display = "block";
  } else {
    bio.style.display = "none";
  }
}
</script>

<style>
.bio-popup {
  background-color: white;
  border: 1px solid #ccc;
  padding: 10px;
  margin-top: 10px;
}
</style>

Acknowledgments 







