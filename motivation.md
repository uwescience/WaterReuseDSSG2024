---
title: "Motivation"
layout: page
---

## Project Goals

There are two main goals of this project: 
- Create a tool that allows web-creators to generate their own website which shows their index of interest, maps it on the US map at varying geospatial scales. End audience will be anyone who faces the website rendered by web-creators. Since different audiences deem certain indicators of the index more important than the other, this website allows audiences to choose their own combination of indicators that they consider significant when constructing the final index. 
- Use this tool to create a website for stakeholders in the water sector to assess and prioritize areas based on their potential benefit from investing in water reuse infrastructure. 

Deliverables include: 
- Index measuring potential benefits that communities can get from water reuse.
- Visualization of that index through mapping
- User interface and generalizable R code that allows users to choose their own components of the index and to map it

## Ethical Considerations

Q) **Anyone** can create **any** type of index. What do we make of it?🤔
- We've had a discussion on potential perils of tool that is too general. With this tool, it allows any stakeholders in any fields to create their own index, making it vulnerable to potential manipulation. We explicitly addressed difficult use cases like selection of a biased set of indicators to get the index they want to use. 
With a series of discussion and feedback from stakeholder engagement interviews, we learned that communities and various interest groups have already been using various tools to portray themselves in ways that favor them. Our tool can indeed empower under-resourced communities to make a more compelling cases to decision makers by utilizing data-driven index and its intuitive visualization. We further decided *not* to offer the option of adjusting weights assigned to indicators as a default feature. This can mitigate the concern of tuning the index value by arbitrarily changing the weight assigned to constituting indicators. 

Q) How do we empower technically less experienced users to the greatest extent? 
- We have spoken with lots of substance-matter experts in the water reuse field who do not use data-analyses much in daily tasks. We thought it is important to make sure that our products can reach the public beyond the data scientists. To address the concern, our website allows end-users to interact with the index by selecting what goes in to calculate the index, and allowing them to download the re-calculated index. 

Q) Why PCA over othe dimensionality-reduction methodologies? 
- After a robust literature review, we have explored different options of calculating index. While there were many compelling methods like archetypal analysis, [ToxiPi](https://github.com/uwescience/WaterReuseDSSG2024/blob/99457ddc865665cc959418b318d7c2a2ddc3819f/code/create_index/toxpi-wrapper.R#L7), we decided to provide weighted-average PCA as a default. This is because PCA provided the most transparent pipeline and allowed subject-matter expert (web-creator) to assign weights.

Q) Should we consider all wastewater to have water reuse potential?
- We need to consider water rights, as some water has to return to waterbodies. There are downstream communities that rely on treated water as their drinking water. 

## Stakeholders

| **User Group** | **Description** |
|----------------|-----------------|
| **Creator**    | Using R code, we publish: <br> • Decide which variables go into the index (must be clean & processed) <br> • Specify weight received by each variable <br> • Specify how index is calculated <br> • Run a script that creates HTML, JS, & R code they can publish as a website (audience is web users) |
| **Web Users**  | Engage with the website, where an interactive map and index creation tool are located. |


Check out our use cases below ⬇️
<div style="overflow-y:auto; max-height:400px;">
  <table style="border-collapse: collapse; width: 100%;">
    <tr style="background-color: #f2f2f2; border-bottom: 1px solid #ddd;">
      <th>User Group</th>
      <th>Description</th>
      <th>Needs</th>
      <th>Skills/Experience</th>
    </tr>
    <tr>
      <td><b>Water reuse researcher (Carolyn)</b></td>
      <td>Carolyn researches water reuse; wants to create an index quantifying potential for reuse across US counties</td>
      <td>Provide cleaned datasets; use output to map index, make a visualization of that input (map) available to nontechnical users via a website</td>
      <td>Ability to load datasets; checks notifying whether datasets are in a format that GeoNDXR can work with; clear functions & workflow to output HTML pages; clear user guide specifying her options with the output | High, focused in R; wants streamlined features to enable focus elsewhere (she doesn’t want to do web dev)</td>
    </tr>
    <tr>
      <td><b>Data journalist (Sarah)</b></td>
      <td>Sarah is a data journalist for a major media company; she supports traditional journalists who want to supplement stories comparing regions in the US with data</td>
      <td>Provide cleaned datasets; use output to map index, make a visualization of that input (map) available to nontechnical users via a website</td>
      <td>Ability to load datasets; checks notifying whether datasets are in a format that GeoNDXR can work with; clear functions & workflow to output HTML pages; clear user guide specifying her options with the output; ability to customize output; transparently explain how indices are calculated | High; focused in R; wants a streamlined workflow for index generation but also needs flexibility</td>
    </tr>
    <tr>
      <td><b>Economic policy analyst (Mike)</b></td>
      <td>Mike is an economic policy analyst for a think tank. He wants to create a regional index displaying how a custom inflation metric has risen differently across parts of the US</td>
      <td>Provide cleaned datasets; use output to map index, make a visualization of that input (map) available to nontechnical users via a website</td>
      <td>Ability to load datasets; checks notifying whether datasets are in a format that GeoNDXR can work with; clear functions & workflow to output HTML pages; clear user guide specifying her options with the output; ability to customize output; transparently explain how indices are calculated | High; focused in R; wants a streamlined workflow for index generation but also needs flexibility</td>
    </tr>
    <tr>
      <td><b>Climate policy researcher (Joe)</b></td>
      <td>Joe is a climate policy researcher at a university. He wants to aggregate different climate risks, produce an index, and make a visualization available to nontechnical users on his GitHub to showcase his work</td>
      <td>Provide cleaned datasets; use output to map index, make a visualization of that input (map) available to nontechnical users via a website</td>
      <td>Ability to load datasets; checks notifying whether datasets are in a format that GeoNDXR can work with; clear functions & workflow to output HTML pages; clear user guide specifying her options with the output; ability to customize output; transparently explain how indices are calculated | High; focused in R; wants a streamlined workflow for index generation but would like flexibility in display options, optimized for GitHub</td>
    </tr>
    <tr>
      <td><b>Data science job market candidate (Daniel)</b></td>
      <td>Daniel is a data science master’s student looking for jobs when he graduates. He is interested in aggregating different metrics, e.g., election polling results, to make predictions about elections. He wants to create an index to predict each congressional district’s outcome in the presidential election (based on more than just polls) and make a clean visualization available on GitHub to showcase his work</td>
      <td>Provide cleaned datasets; use output to map index, make a visualization of that input (map) available to nontechnical users via a website</td>
      <td>Ability to load datasets; checks notifying whether datasets are in a format that GeoNDXR can work with; clear functions & workflow to output HTML pages; clear user guide specifying her options with the output; ability to customize output; transparently explain how indices are calculated | High; focused in R; wants a streamlined workflow for index generation but would like flexibility in display options, optimized for GitHub</td>
    </tr>
    <tr>
      <td><b>EPA employee</b></td>
      <td></td>
      <td>He needs an interface that he can use to find locations that need water reuse facilities the most. He wants an interactive interface that he can use to study and understand the need for water reuse infrastructure in various places in the US.</td>
      <td>He has no programming experience</td>
    </tr>
    <tr>
      <td><b>Utility Employee (Aisha)</b></td>
      <td>Aisha is an employee of a utility company that is considering expanding into the water reuse area.</td>
      <td>She wants to see places that are in dire need of water reuse. She needs an interactive application that she can use to visually see these places and give valuable recommendations to the company.</td>
      <td>She has no experience in R coding</td>
    </tr>
    <tr>
      <td><b>Community member</b></td>
      <td>She heard about water reuse and is inspired by it.</td>
      <td>She wants to learn more about it. She wants a less complicated and easy-to-understand web application interface that she can easily use to view the water reuse needs of different US counties and the reasons for this need.</td>
      <td>She has no programming and industry knowledge</td>
    </tr>
    <tr>
      <td><b>XYZ Water Reuse consultancy firm employee (Betty)</b></td>
      <td>One of the consultancy clients is a utility company that is considering establishing a water reuse facility.</td>
      <td>Betty wants to build a credible interactive web application index that she can use to view places in absolute need of water reuse facilities and the profitability potential of these facilities.</td>
      <td>She has technical and industrial knowledge.</td>
    </tr>
    <tr>
      <td><b>Researcher</b></td>
      <td>She needs a tool that she can use to create a feasibility index and display them on an interactive web application.</td>
      <td>She wants to build a water reuse feasibility index, where she can incorporate economic, environmental, and technical feasibility measures.</td>
      <td>She is proficient in R</td>
    </tr>
    <tr>
      <td><b>Gambia National Water and Electricity Company (NAWEC) Employee</b></td>
      <td></td>
      <td>The company is planning to build an index that will help them identify the regions in need of wastewater treatment facilities. As the analyst at the company, he needs a tool that he can use to create the index and display it on an interactive web application.</td>
      <td>He has years of experience working with data and R.</td>
    </tr>
    <tr>
      <td><b>Data scientist (Curtis)</b></td>
      <td>Curtis is a data scientist at eScience Institute.</td>
      <td>He would like to be able to build some cool tech that he can teach to other technical people at the eScience Institute in order to make their work better. This means that he needs a fully functioning pipeline that does something nifty and is well-written both in code and comments.</td>
      <td>He's super technically proficient.</td>
    </tr>
    <tr>
      <td><b>Journalist (Kendrick)</b></td>
      <td>Kendrick is a journalist working for 538.</td>
      <td>He wants to be able to show the relationship between an index that he is interested in (industrial jobs) and changes in polling in the presidential race since JD Vance was nominated as VP. He would like to be able to overlay an explorable index and a different variable so that the geographical relationship becomes obvious.</td>
      <td>He is a proficient technical user with experience cleaning data but a busy journalist.</td>
    </tr>
    <tr>
      <td><b>Suzannah, college student</b></td>
      <td>Suzannah is a college student with a slight smartphone addiction.</td>
      <td>She got really upset that Seattle wasn't the "most livable" city in the recent Zillow livability index and wants to know what factors were included and how that would change if there were different factors included. She would like to be able to save her index that shows Seattle to be the most livable city.</td>
      <td>She spends most of her time at a lab bench and isn't very familiar with data analysis, except for that one stats class everyone had to take.</td>
    </tr>
    <tr>
      <td><b>Zach, researcher</b></td>
      <td>Zach is a researcher studying a new way to learn about homelessness that he thinks will work best in areas of a certain type.</td>
      <td>He would like to quickly throw in some census data and find places similar to and different from Seattle to test this new process. He wants to be able to use that as a part of a grant application.</td>
      <td>He is highly technically proficient.</td>
    </tr>
    <tr>
      <td><b>Gates Foundation Employee (Sam)</b></td>
      <td>Sam works at the Gates Foundation, which is giving money to different projects that meet some threshold of need and positive impact.</td>
      <td>He wants to be able to easily adjust an index to represent different needs and interactively show the impact the project will have. Sam also wants to be able to make modifications on the fly and export the results in a web-readable format.</td>
      <td>He is highly proficient with R.</td>
    </tr>
    <tr>
      <td><b>Sales (Kathryn)</b></td>
      <td>Kathryn works in sales for a company that sells wastewater equipment.</td>
      <td>She wants to be able to use an index to visually identify regions that are in absolute need of wastewater equipment.</td>
      <td>She has technical and industrial knowledge.</td>
    </tr>
  </table>
</div>
