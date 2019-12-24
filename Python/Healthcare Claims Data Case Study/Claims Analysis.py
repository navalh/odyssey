#Some ideas to improve this analysis are:
#a) Visualizations of Key Results
#b) Investigating other NPI databases for a successful join
#c) Investigating prescription data and payment variables to see which opioid drugs were commonly prescribed (and to calculate ASP)

#Loading libraries needed for this analysis
import numpy as np
import pandas as pd
import os.path

#Paths for importing raw data
raw_path = 'C:\\Users\\Naval\\Documents\\Point72 Case\\Raw Data'

opclaims_path = os.path.join(raw_path, 'DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv')
ben_08_path = os.path.join(raw_path, 'DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv')

#Import datasets into Python
opclaims = pd.read_csv(opclaims_path, dtype = str)
ben_08 = pd.read_csv(ben_08_path, dtype = str)

#Subset Outpatient claims to those with Opioid dependence 
opioid = opclaims[(opclaims.ICD9_DGNS_CD_1.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_2.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_3.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_4.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_5.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_6.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_7.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_8.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_9.str.startswith('3040')) | (opclaims.ICD9_DGNS_CD_10.str.startswith('3040'))]
opioid = opioid.fillna("")

opioid_pct = (len(opioid.index)/len(opclaims.index)) * 100
#Notice opioid claims account for only 0.03% of the entire sample

#NPI database sourced from [http://download.cms.gov/nppes/NPI_Files.html] did not match with any of the NPIs in our opioid subset
#Codebook at [https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/SynPUF_Codebook.pdf] describes how NPI is randomly generated and cautions any analysis with this field

#Only using the 2008 benefits file because an inner join preserved all the records in the opioid dataset
opioid_ben = pd.merge(opioid, ben_08, on = 'DESYNPUF_ID')

#State Demographic distribution
state_demo = opioid_ben.groupby(['SP_STATE_CODE']).size().reset_index(name='count')
state_demo = state_demo.sort_values(by='count', ascending=False)
#Most patients come from CA (20/212), OH (15/212), NY (15/212), FL (13/212), NC (13/212)

#Gender Demographic distribution
gender_demo = opioid_ben.groupby(['BENE_SEX_IDENT_CD']).size().reset_index(name='count')
gender_demo = gender_demo.sort_values(by='count', ascending=False)
#Most patients are female (125/212), goes against publicized statistics

#Race Demographic distribution
race_demo = opioid_ben.groupby(['BENE_RACE_CD']).size().reset_index(name='count')
race_demo = race_demo.sort_values(by='count', ascending=False)
#Most patients are white (175/212)

#Pull the relevant diagnosis codes from the relevant 10 columns to calculate their distribution
diag_codes1 = opioid[(opioid.ICD9_DGNS_CD_1.str.startswith('3040'))]['ICD9_DGNS_CD_1']
diag_codes2 = opioid[(opioid.ICD9_DGNS_CD_2.str.startswith('3040'))]['ICD9_DGNS_CD_2']
diag_codes3 = opioid[(opioid.ICD9_DGNS_CD_3.str.startswith('3040'))]['ICD9_DGNS_CD_3']
diag_codes4 = opioid[(opioid.ICD9_DGNS_CD_4.str.startswith('3040'))]['ICD9_DGNS_CD_4']
diag_codes5 = opioid[(opioid.ICD9_DGNS_CD_5.str.startswith('3040'))]['ICD9_DGNS_CD_5']
diag_codes6 = opioid[(opioid.ICD9_DGNS_CD_6.str.startswith('3040'))]['ICD9_DGNS_CD_6']
diag_codes7 = opioid[(opioid.ICD9_DGNS_CD_7.str.startswith('3040'))]['ICD9_DGNS_CD_7']
diag_codes8 = opioid[(opioid.ICD9_DGNS_CD_8.str.startswith('3040'))]['ICD9_DGNS_CD_8']
diag_codes9 = opioid[(opioid.ICD9_DGNS_CD_9.str.startswith('3040'))]['ICD9_DGNS_CD_9']
diag_codes10 = opioid[(opioid.ICD9_DGNS_CD_10.str.startswith('3040'))]['ICD9_DGNS_CD_10']

diag_codes = diag_codes1.append(diag_codes2).append(diag_codes3).append(diag_codes4).append(diag_codes5).append(diag_codes6).append(diag_codes7).append(diag_codes8).append(diag_codes9).append(diag_codes10)
diag_codes = pd.DataFrame(diag_codes.reset_index(name = "diagnosis_code")["diagnosis_code"])

#Diagnosis Code distribution
diag_codes_dist = diag_codes.groupby(['diagnosis_code']).size().reset_index(name='count')
diag_codes_dist = diag_codes_dist.sort_values(by='count', ascending=False)
print(diag_codes_dist)

#After unspecified type, continuous opioid dependence is most common (51/217)