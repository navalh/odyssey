# Audit -----------------------------------------------------------------
# Created by: NH
# Created on: 7/30/2018

# Purpose: Analyse 90% patient service areas for all "unnamed" Hospitals in California.

# Code ------------------------------------------------------------------
########## STEP 1: Create 90% Patient Service Areas based on unnamed Hospital discharges in their respective HSAs;
########## Find list of hospitals inside each PSA that discharge atleast 2% of that PSA's total discharges.


#The 3 datasets to be used in this analysis
exhibits_disch <- "discharges.rds"
hosp_to_hsa <- "hospital_hsa_lookup.rds"
hosp_data <- "hospital_data.rds"

#Subset of hospitals relevant for our analysis
unnamed_2011 <- hosp_data %>%
  filter(oshpd_year == "2011" & (is.na(fac_no_parent) | fac_no == fac_no_parent)
         & system_name_to_use_2011 == "unnamed HEALTH" & toupper(type_care) %in% c("GENERAL", "GENERAL ACUTE")) %>%
  select(oshpd_id = fac_no, facility_name = fac_name, zip_code_brg) %>%
  left_join(hosp_to_hsa, by = "oshpd_id")

#Subset of all hospitals relevant for our analysis
hosp_2011 <- hosp_data %>%
  filter(oshpd_year == "2011" & (is.na(fac_no_parent) | fac_no == fac_no_parent)
         & toupper(type_care) %in% c("GENERAL", "GENERAL ACUTE")) %>%
  select(oshpd_id = fac_no, facility_name = fac_name, zip_code_brg) %>%
  left_join(hosp_to_hsa, by = "oshpd_id")

#Counts of all patient discharges by zipcode
total_disch_per_zip <- exhibits_disch %>%
  group_by(patzip) %>%
  summarize(zip_total_discharges = n())

#Calculating the zipcodes that belong to the 90% Patient Service Areas
disch_per_zip_by_hsa <- exhibits_disch %>%
  inner_join(unnamed_2011, by = c("oshpd_id_long" = "oshpd_id")) %>%
  mutate(hsa_name = case_when(hsa_name == "Berkeley" ~ "Berkeley-Oakland", hsa_name == "Oakland" ~ "Berkeley-Oakland", TRUE  ~ hsa_name)) %>%
  group_by(hsa_name, patzip) %>%
  summarize(num_unnamed_discharges = n()) %>%
  left_join(total_disch_per_zip, by = "patzip") %>%
#  group_by(hsa_name) %>%
  mutate(tot_unnamed_disch = sum(num_unnamed_discharges),
         unnamed_share_of_zip = num_unnamed_discharges/zip_total_discharges) %>%
  arrange(hsa_name, -unnamed_share_of_zip) %>%
  mutate(zip_share_of_unnamed = num_unnamed_discharges/tot_unnamed_disch,
         cum_pct = cumsum(zip_share_of_unnamed),
         prev_cum_pct = lag(cum_pct)) %>%
  mutate(in_90pct_psa = ifelse(cum_pct < .9 | prev_cum_pct < .9, 1, 0)) %>% #Include CPMC's zip in PSA
  arrange(hsa_name, -unnamed_share_of_zip)

#Used for 2% filter criterion - has all the discharges of all the hospitals and their weighted share for each zipcode.
disch_per_zip_by_all_hospital <- exhibits_disch %>%
  group_by(oshpd_id_long, patzip) %>%
  summarize(num_discharges = n()) %>%
  inner_join(hosp_2011, by = c("oshpd_id_long" = "oshpd_id")) %>%
  arrange(oshpd_id_long, -num_discharges) %>%
  left_join(total_disch_per_zip, by = "patzip") %>%
  mutate(hospital_share_of_zip = num_discharges/zip_total_discharges,
         hsa_name = case_when(hsa_name == "Berkeley" ~ "Berkeley-Oakland", hsa_name == "Oakland" ~ "Berkeley-Oakland", TRUE  ~ hsa_name)) %>%
  left_join(select(disch_per_zip_by_hsa, hsa_name, patzip, unnamed_share_of_zip), by = c("hsa_name", "patzip")) %>%
  mutate(weighted_share = unnamed_share_of_zip*hospital_share_of_zip)
#Note this weighted share is not complete - this share will get summed for each zipcode, and then divided by the sum of the weights for the PSA.

#Helper function that returns a vector of zip codes in a given Patient Service Area.
zip_list_by_psa <- function(hsa) {
  as.data.frame(disch_per_zip_by_hsa) %>%
    filter(hsa_name == hsa & in_90pct_psa == 1) %>%
    ungroup(hsa_name) %>%
    pull(patzip)
}

#Helper function that returns the numerator of the weighted share of a hospital in a collection of zipcodes (such as a PSA).
weighted_share_filter <- function(hospital, psa_name) {
  as.data.frame(disch_per_zip_by_all_hospital) %>%
    filter(facility_name == hospital & patzip %in% zip_list_by_psa(psa_name)) %>%
    summarize(hosp_weighted_share_in_psa = sum(weighted_share)) %>%
    pull(hosp_weighted_share_in_psa)
}

#Helper function that returns the denominator of the weighted share of a hospital in a collection of zipcodes (such as a PSA).
sum_of_weights <- function(hsa) {
  as.data.frame(disch_per_zip_by_hsa) %>%
    filter(hsa_name == hsa & in_90pct_psa == 1) %>%
    summarize(weight_sum = sum(unnamed_share_of_zip)) %>%
    pull(weight_sum)
}

#Unique vector of relevant HSAs
hsa_list <- disch_per_zip_by_hsa %>%
  select(hsa_name) %>%
  distinct %>%
  pull(hsa_name)

#Unique vector of hospital names
hosp_list <- disch_per_zip_by_all_hospital %>%
  ungroup(oshpd_id_long, patzip) %>%
  select(hosp_name = facility_name) %>%
  distinct %>%
  pull(hosp_name)

#Cross joined list of hospitals and HSAs
psa_hospitals <- merge(hosp_list, hsa_list, by = NULL) %>%
  mutate(hosp_weighted_share_in_psa = 0) %>%
  as.data.frame
#Rename columns
names(psa_hospitals) <- c("hosp_name", "hsa_name", "hosp_weighted_share_in_psa")

#Calculate weighted share for each hospital-HSA pair
for (i in 1:length(psa_hospitals[,1])) {
  psa_hospitals[i,3] = weighted_share_filter(psa_hospitals[i,1], psa_hospitals[i,2])/sum_of_weights(psa_hospitals[i,2])
}


relevant_hsas <- c("Antioch", "Auburn", "Berkeley-Oakland", "Crescent City", "Davis", "Jackson", "Lakeport", "Tracy", "Modesto", "Sacramento", "San Francisco", "Santa Rosa")

#List of hospitals in each PSA
psa_hospitals_out <- psa_hospitals %>%
  filter(hosp_weighted_share_in_psa >= 0.02 & hsa_name %in% relevant_hsas) %>%
  arrange(hsa_name, -hosp_weighted_share_in_psa) %>%
  inner_join(hosp_2011, by = c("hosp_name" = "facility_name")) %>%
  select(psa_hsa = hsa_name.x, hosp_name, hosp_hsa = hsa_name.y, hosp_weighted_share_in_psa)

#Export
wb <- createWorkbook()

addWorksheet(wb, "90% Patient Service Areas")
writeData(wb, "90% Patient Service Areas", disch_per_zip_by_hsa)
saveWorkbook(wb, "90_patient_service_areas_OUTPUT.xlsx")

addWorksheet(wb, "Hospitals in PSAs")
writeData(wb, "Hospitals in PSAs", psa_hospitals_out)
saveWorkbook(wb, "90_patient_service_areas_OUTPUT.xlsx")

########## STEP 2: Map the PSAs of unnamed Hospitals in Tied/Tying HSAs, which contains outlines of the neighbouring HSA and hospitals 'part' of each PSA;

zip_shape <- readShapePoly("mapping/zcta/tl_2010_06_zcta510.shp")
zip_locations <- fortify(zip_shape, region = "ZCTA5CE10") %>%
  mutate(davis_flag = case_when(id %in% zip_list_by_psa("Davis") ~ 1, TRUE  ~ 0),
         sf_flag = case_when(id %in% zip_list_by_psa("San Francisco") ~ 1, TRUE  ~ 0),
         modesto_flag = case_when(id %in% zip_list_by_psa("Modesto") ~ 1, TRUE  ~ 0),
         sacramento_flag = case_when(id %in% zip_list_by_psa("Sacramento") ~ 1, TRUE  ~ 0),
         antioch_flag = case_when(id %in% zip_list_by_psa("Antioch") ~ 1, TRUE  ~ 0),
         auburn_flag = case_when(id %in% zip_list_by_psa("Auburn") ~ 1, TRUE  ~ 0),
         berk_oak_flag = case_when(id %in% zip_list_by_psa("Berkeley-Oakland") ~ 1, TRUE  ~ 0),
         crescent_flag = case_when(id %in% zip_list_by_psa("Crescent City") ~ 1, TRUE  ~ 0),
         jackson_flag = case_when(id %in% zip_list_by_psa("Jackson") ~ 1, TRUE  ~ 0),
         lakeport_flag = case_when(id %in% zip_list_by_psa("Lakeport") ~ 1, TRUE  ~ 0),
         tracy_flag = case_when(id %in% zip_list_by_psa("Tracy") ~ 1, TRUE  ~ 0),
         santa_rosa_flag = case_when(id %in% zip_list_by_psa("Santa Rosa") ~ 1, TRUE  ~ 0))

zip_hsa_crosswalk <- read_excel("crosswalks/ZipHsaHrr11.xls")

hsa_locations1 <- readRDS("clean/hsa/relevant_hsas_norcal_flags.RDS")
hsa_locations <- hsa_locations1 %>%
  mutate(hsa_name = substr(as.character(HSANAME), 5, nchar(as.character(HSANAME)))) #Make HSA names similar to our current PSA outputs

hosp_locations <- readRDS("clean/hospital_list/clean_hospital_list.rds")

psa_map <- function(flag_name, psa_name) {
  hosp_in_psa <- hosp_2011 %>%
    select(oshpd_id, facility_name) %>%
    mutate(oshpd_id = substr(oshpd_id, 4, 9)) %>% #Drop first 3 characters of OSHPD ID to resemble the hosp_locations' OSHPD IDs
    inner_join(filter(psa_hospitals_out, hsa_name == psa_name), by = c("facility_name" = "hosp_name")) %>%
    select(oshpd_id)
  hosp_in_psa_locations <- hosp_locations %>%
    inner_join(hosp_in_psa, by = "oshpd_id")

  hsa_in_psa <- zip_hsa_crosswalk %>%
    filter(zipcode11 %in% zip_list_by_psa(psa_name)) %>%
    select(hsacity) %>%
    distinct %>%
    pull(hsacity)
  hsa_in_psa_locations <- hsa_locations %>%
    filter(hsa_name %in% toupper(hsa_in_psa))

  zip_in_psa_locations <- zip_locations %>%
    filter(get(flag_name)== 1)

  ggplot() +
    geom_polygon(data = zip_in_psa_locations,
                 aes(x = long, y = lat, group = group),
                 fill = "gold",
                 alpha = .75) +
    geom_polygon(data = hsa_in_psa_locations,
                 aes(x = long, y = lat, group = group),
                 color = "blue",
                 fill = NA) +
    geom_point(data = hosp_in_psa_locations,
                 aes(x = longitude, y = latitude, shape = factor(ownership)),
                 color = "black",
                 fill = NA) +
    # geom_text_repel(data = hosp_in_psa_locations,
    #                 size = 2.25,
    #                 force = 5,
    #                 aes(x = longitude, y = latitude, label = hospital),
    #                 family = "Arial",
    #                 box.padding = unit(2, "lines")) +
    coord_quickmap() +
    theme_map()
    # theme(legend.position = 'left',
    #       plot.margin = unit(c(0,0,0,0), 'cm'))
}

export_map <- function(final_map, title) {
  graph_title <- list(title = paste0("90% Patient Service Area", title))
  source_text <- list(source_txt = "Source: 2011 OSHPD Discharge Data; Dartmouth Atlas \n\n
                      Note:  For each tied/tying HSA, the collection of unnamed hospitals geographically 
                      located within the HSA are examined to calculate where 90 percent of its grouped discharged patients live.
                      To determine a 90 percent Patient Service Area, patient zipcodes are ranked by how many 
                      discharges within a zipcode belong to the unnamed hospitals in consideration (unnamed's share 
                      of that zipcode's discharges).  The ordered set of all zipcodes that cumulatively contribute at
                      least 90 percent of the collection of unnamed hospitals' patient discharges define the 90 percent PSA.
                      A non-unnamed hospital belongs to a given 90 percent PSA if it is responsible for at least a 2 percent 
                      weighted average share of all discharges in the collection of zipcodes that form the relevant PSA.  
                      The percent of each zipcode's discharges belonging to that non-unnamed hospital is calculated, 
                      then weighted by unnamed's share of that zipcode's discharges and averaged across each zipcode 
                      in the PSA to form a weighted average.")
  plot <- align_plot_elements(final_map, graph_title, source_text, row_heights = c(2, 8, 2.5))
  ggsave(plot, header$export(paste0("maps/", "90pct Patient Service Area of ", title, ".pdf")))
}

davis_map <- psa_map("davis_flag", "Davis")
export_map(davis_map, "unnamed Davis Hospital")

sf_map <- psa_map("sf_flag", "San Francisco")
export_map(sf_map, "CPMC & St. Luke's")

modesto_map <- psa_map("modesto_flag", "Modesto")
export_map(modesto_map, "unnamed Modesto Hospital")

sacramento_map <- psa_map("sacramento_flag", "Sacramento")
export_map(sacramento_map, "unnamed Medical Center, Sacramento")

antioch_map <- psa_map("antioch_flag", "Antioch")
export_map(antioch_map, "unnamed Delta Medical Center")

auburn_map <- psa_map("auburn_flag", "Auburn")
export_map(auburn_map, "unnamed Auburn Faith")

berk_oak_map <- psa_map("berk_oak_flag", "Berkeley-Oakland")
export_map(berk_oak_map, "Berkeley-Oakland Medical Center")

crescent_map <- psa_map("crescent_flag", "Crescent City")
export_map(crescent_map, "unnamed Crescent City Hospital")

jackson_map <- psa_map("jackson_flag", "Jackson")
export_map(jackson_map, "unnamed Jackson Hospital")

lakeport_map <- psa_map("lakeport_flag", "Lakeport")
export_map(lakeport_map, "unnamed Lakeport Hospital")

tracy_map <- psa_map("tracy_flag", "Tracy")
export_map(tracy_map, "unnamed Tracy Hospital")

santa_rosa_map <- psa_map("santa_rosa_flag", "Santa Rosa")
export_map(santa_rosa_map, "unnamed Santa Rosa Hospital")

