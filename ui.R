# General Informaiton: 
##################################################
# INFO 201, Autumn 2016, Secton AB
# Team name: Not Really Sure
# Contributors: Jason You, Alison McGuire, Matthew Tran

# Shiny app ui
##################################################

#Script Sources and Modules: 
##################################################
# source("scripts/installPackage.R")
# installPackage(c("shinythemes", "shiny", "leaflet", "markdown"))  # deprecated
# install.packages(c("shinythemes", "shiny", "leaflet", "markdown"))
require(shinythemes)
require(shiny)
require(leaflet)
require(markdown)

# Alison
source('alisons_scripts/script.R')
##################################################

# Jason
university_name <- get(load("data/newData/university_name.Rda"))

# Main: 
##################################################

# see example: https://shiny.rstudio.com/gallery/navbar-example.html
# for more information on how to structure your portion of this function

# Define UI for application that visualizing the University data
shinyUI(
  
  # Use shiny theme "yeti"
  navbarPage("World Top Universites", theme = shinytheme("yeti"),
             
                #Jason's Tabs
                ##############################################
               # Jason: Visualize all the top Universities in the world in different years 
               tabPanel("World map",
                  div(class="outer",
                      tags$head(
                        # Include the CSS features
                        includeCSS("style.css")
                      ),
                      
                      leafletOutput("world_map", width = "100%", height = "100%"),
                      
                      absolutePanel(id = "controls", fixed = TRUE, draggable = TRUE,
                                    top = "auto", left = 25, right = "auto", bottom = 30,
                                    width = 330, height = 366,
                                    
                                    h2("World Universities"),
                                    
                                    # select which year of the data (2011 to 2016) to use
                                    sliderInput("select_year", "Year of data to use:", 
                                                min = 2011, max = 2016,
                                                value = 2015, step = 1, ticks = FALSE,
                                                animate = TRUE
                                    ),
                                    
                                    plotlyOutput("getChoroplethMap", height = 200)
                      )
                  )
               ),
             
               # Jason: The local map to show the bars around the given University
               tabPanel("Bars Around",
                  div(class="outer",
                      tags$head(
                        # Include the CSS features
                        includeCSS("style.css")
                      ),
                      
                      leafletOutput("local_map", width = "100%", height = "100%"),
                      absolutePanel(id = "controls", fixed = TRUE, draggable = TRUE,
                                    top = "15%", left = "5%", right = "auto", bottom = "auto",
                                    width = 330, height = "auto",
                                    
                                    plotlyOutput("getBarPlot", height = 200),
                                    
                                    # select which year of the data (2011 to 2016) to use
                                    selectInput("university", "University", university_name,
                                             selected = "University of Washington Seattle")
                                    
                      )
                   )
                ),
               ###################################################

               # Alison's Tab
               ######################################
               tabPanel("Ratings Plot",
                        sidebarLayout(
                          sidebarPanel(
                            # Gets year input
                            selectInput("get.year", label = h3("Select Year"), 
                                        choices = list("All Years" = 'All', "2011" = 2011, "2012" = 2012, "2013" = 2013, 
                                                       "2014" = 2014, "2015" = 2015, "2016" = 2016), selected = 'All'),
                            # Gets country input
                            textInput("get.country", label = h3("Enter Name of Country"), value = "All"),
                            # Gets variable input
                            radioButtons("variable", label = h3("Type of Variable"),
                                         choices = list("Total Score" = 'total_score', "Teaching Score" = 'teaching', 
                                                        "Research Score" = 'research', "Income Score" = 'income', 
                                                        "Number of Students" = 'num_students', 
                                                        "Student to Staff Ratio" = 'student_staff_ratio',
                                                        "Percentage of International Students" = 'international_students',
                                                        "Female to Male Ratio" = 'female_male_ratio'), selected = 'total_score')
                           
                            ),
                          #output a plotly graph called "Ratings"
                          mainPanel(plotlyOutput("Ratings"))
                        )
               ),
              ########################################
     
               # Matthew's Tab
               ###########################################
               tabPanel("Rankings By Country", 
                        sidebarLayout(
                          sidebarPanel(
                            h5("Pick To View Rankings By Country"),
                            selectInput("country", " Country:", 
                                        choices = list("Argentina", "Australia", "Austria", "Belgium", "Brazil", "Bulgaria", "Canada", "Chile",
                                                       "China", "Croatia", "Cyprus", "Czech Repulic", "Denmark", "Egypt", "Estonia", "Finland",
                                                       "France", "Germany", "Greece", "Hong Kong", "Hungary", "Iceland", "India", "Iran",
                                                       "Ireland", "Israel", "Italy", "Japan", "Lebanon", "Lithuania", "Malaysia", "Mexico",
                                                       "Netherlands", "New Zealand", "Norway", "Poland", "Portugal", "Puerto Rico", "Romania",
                                                       "Russia", "Saudi Arabia", "Serbia", "Singapore", "Slovak Republic", "Slovenia",
                                                       "South Africa", "South Korea", "Spain", "Sweden", "Switzerland", "Taiwan","Thailand",
                                                       "Turkey", "Uganda", "United Arab Emirates", "United Kingodm", "Uruguay", "USA"))
                        ),
                          mainPanel(
                            h2("Ranking of University By Score"),
                            h5("Universities are scored on a scale of 0-100, which is used to determine world rank"),
                            plotlyOutput('ranking')
                          )
                        )
               ),
              ######################################
               
               # Summary Tab
               ######################################
               navbarMenu("More",
                 tabPanel("About",
                        includeMarkdown("More/about.md")
                 ),
                 tabPanel("How To",
                        includeMarkdown("More/howto.md")
                 ),
                 tabPanel("Contributions",
                          includeMarkdown("More/summary.md")
                 )
               )
               ######################################
    )
    
    #####################################################
)
