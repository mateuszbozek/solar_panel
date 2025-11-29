# README

This README would normally document whatever steps are necessary to get the
application up and running.

For running this application, you will need to have Ruby and Rails installed on your computer.
You need ruby version 3.3.5 and rails version 7.2.3.

## Setup Instructions
1. Download project from the repository.

2. In any IDE, open the project folder.

3. Go to IDE terminal.

4. If you have installed ruby and rails, run bundle install to install the required gems.
-- bundle install --

5. To start the server, run the following command:
-- rails s --

6. Open your web browser and go to http://localhost:3000 to see the application running.
   If you see JSON response:

   {"solar_panel":"Is alive!"}

   That means your application is running successfully.

7. Project has only one endpoint for calculating positions of mounts and joints of solar panel.
   You can test it using Postman or any other API testing tool.

   Application calculate the coordinates for mounts and joints of solar panel. Every panel is described by 2 points:
   {x: 1,y: 2}

   For running calculation, make a POST request to the following URL:
   http://localhost:3000/get_coordinates_joints_and_mounts

   With the following example of JSON body:
   { 
     "data": [ 
        {"x": 0, "y": 0},
        {"x": 20, "y": 0},
        {"x": 40, "y": 0},
        {"x": 0, "y": 71.6},
        {"x": 135.15, "y": 0},
        {"x": 135.15, "y": 71.6}  ]
    }

   You should receive a JSON response with calculated positions for mounts and joints. 


