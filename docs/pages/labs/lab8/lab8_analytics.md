---
title: Browse the Analytics Data in API Connect
toc: false
sidebar: labs_sidebar
folder: labs/lab8
permalink: /lab8_analytics.html
summary: Explore the Analytics capabilities within IBM API Connect. 
applies_to: [administrator]
---

## Launch the API Manager

1.  Launch your API Connect service from [IBM Bluemix](https://console.ng.bluemix.net/){:target="_blank"}.

1.  Click on the `Sandbox` catalog tile.

1.  From the `Sandbox` catalog configuration screen, click on the `Analytics` tab.

    ![](./images/labs/lab8/analytics-tab.png)

## Explore the Analytics

1.  The default dashboard gives some general information like the five most active Products and 5 most active APIs.  This information is interesting, but there are other dashboards we can view that provide more data.

1.  Click on the `Load Saved Dashboards` icon to open up the dashboard list. Select the `api-default` dashboard.

    ![](./images/labs/lab8/switch-dashboards.png)

1.  Here you will see some interesting visualizations that show graphs and charts with information about the API Traffic that was processed.

    {% include tip.html content="
        Visualizations are queries into the data. You can move the visualization boxes around the dashboard and resize them. You can also add more visualizations to the dashboard, or customize the data queries of the existing ones. Once you have the dashboard the way you like it, you can save it and pull it back up any time you wish.
    " %}

1.  Analytics data can be filtered over different time periods, and the visualization boxes can even be automatically refreshed. Click on the calendar icon which specifies the default time period of `Last 7 days`.

    ![](./images/labs/lab8/last-7-days.png)

1.  Set the **Time Range** to `Today`.
	
1.  Click on `Auto Refresh` and set the refresh period to `5 seconds`.

    ![](./images/labs/lab8/auto-refresh.png)

1.  Return to the consumer application in the Chrome web browser. Navigate around the site and test out some of the features in order to generate some additional API calls.

1.  Return back to the analytics view and notice how the data is refreshed automatically.

## Completion

**Congratulations!** You have completed all of the labs!