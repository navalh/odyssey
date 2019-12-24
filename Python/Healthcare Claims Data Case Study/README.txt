This program was created by Naval Handa as part of a case study analyzing outpatient health insurance claims data from the CMS website. 
I extracted a subset of claims that map to patients diagnosed with opioid dependence to see whether there may be some investment signals in this data to help you trade stocks of pharma and biotech companies that manufacturer drugs that treat opioid dependence.


I went to the CMS Website and downloaded DE1.0Sample_1. 
This takes you to a self-contained set of sample data (beneficiary data, inpatient data, outpatient data, etc.) for a single sample population.

Some questions I was curious to answer:
o	Who the physicians are by using the NPI column, and aggregating to see where patients are treated (state, city, hospital type, etc.) if you map this to a NPI database
o	Who the patients are by using the DESYNPUF_ID to join with the beneficiary summary file and get additional columns on patient demographics
