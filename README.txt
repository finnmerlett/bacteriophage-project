 
 This folder contains all the MATLAB code from Finn Merlett's research project into PAS
 with E.coli, T4 phage and the antibiotics Ampicillin and Streptomycin this 
 academic year. 
 
 
 EXPERIMENTAL PLATES: LAYOUT -------------------------------------------
 
 Experimental plate layout:
 (also found in \Experimental plate reads\Concentration layout matrix.xlsx)
 ┌──────────────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┬────────┐
 │ 5000 →  5.00 │ 3.536 │ 2.500 │ 1.768 │ 1.250 │ 0.884 │ 0.625 │ 0.442 │   0   │   LB   │
 ├──────────────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼────────┤
 │ 1581 →   ↓   │   ↓   │   ↓   │   ↓   │   ↓   │   ↓   │   ↓   │   ↓   │   ↓   │   LB   │
 ├──────────────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼────────┤
 │ 500  →       │       │       │       │       │       │       │       │       │   LB   │
 ├──────────────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼────────┤
 │ 158  →       │       │       │       │       │       │       │       │       │ E.coli │
 ├──────────────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼────────┤
 │ 50   →       │       │       │       │       │       │       │       │       │ E.coli │
 ├──────────────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼───────┼────────┤
 │ 0    →       │       │       │       │       │       │       │       │       │ E coli │
 └──────────────┴───────┴───────┴───────┴───────┴───────┴───────┴───────┴───────┴────────┘
 
 Values on the left hand side, starting at 5000, are phage concentration, (units
 PFU/ml). Rightward arrows indicate that concentration along each row. Values 
 along the top, starting at 5.00, are antibiotic concentration (units μg/ml).
 Downward arrows indicate that concentration down each column. The final column
 is controls. Each timepoint is on a separate sheet within the file arranged in
 chronological order, with reads separated by 10 minute intervals.
 
 All wells used LB (high salt) as the medium, and E. coli was present in all
 wells at 10e7 CFU/ml (except those marked 'LB').
 
 Filenames for the experimental plate reads have the following structure:
 "[antibiotic used (shorthand)] [date] [type of read].xlsx"
 Antibiotic shorthands used: Amp = Ampicillin, Strep = Streptomycin
 Types of read are as follows:
   • single read: single OD reading per well per timepoint
   • Xmm avg: obital average reading per well per timepoint, diameter = Xmm
 
 
 HOW TO USE THE MATLAB CODE FILES -------------------------------------------
   
   • Download entire folder to your computer
   • Add folder 'MATLAB code' and all subfolders to path, within MATLAB
   • Use '\MATLAB code\Bacteriophage proj\Utility functions\xlsx_tidy.m' to 
     prepare your Excel data into a consistent format across files, to be
     imported. This can be skipped if your data is already consistent, but is
     still recommended.
   • See '\Example data' for data format and filename structure (before tidying)
     [filename structure: 'antibiotic date description.xlsx']
     See '\Example data\Tidied data' for example tidied output'
   • Use '\MATLAB code\Bacteriophage proj\Utility functions\Import_data.m' to
     load your tidied Excel file into a MATLAB struct containing all the details
     in separate fields. If you are loading many files, you can set up a loop to
     add them all as separate index entries of the same struct. Save the stuct 
     as 'Imported_Experimental_Data.mat' to use later
   • Modify '\MATLAB code\Bacteriophage proj\Strep_setup.m' to load your data
     and filter according to which antibiotic you are using. Options for
     processing and plotting are documented in the file.

   Good luck!
