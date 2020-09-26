  user=zhanghg
  filenumber=3
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_energy_pion_350_3
  even=6
  odd=12    
  cut=400


  rm -r /store/bl2/scratch/$user/${AnaDirectory}
  mkdir /store/bl2/scratch/$user/${AnaDirectory}



#------------------------------------------------
# create directories to save and sort all the files
#------------------------------------------------
  mkdir /store/bl2/scratch/$user/${AnaDirectory}
  mkdir /store/bl2/scratch/$user/${AnaDirectory}
  mkdir /store/bl2/scratch/$user/${AnaDirectory}/code
  mkdir /store/bl2/scratch/$user/${AnaDirectory}/rootfile
  mkdir /store/bl2/scratch/$user/${AnaDirectory}/condorfile
  mkdir /store/bl2/scratch/$user/${AnaDirectory}/condorlog




#------------------------------------------------
# create pedestalmaterials
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/pedestalmaterials.C <<-EOA

#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>


  
  TH1D * pedestalmaterials(TString filename,  TString ribbon, TString condition)
{

  double hNum = 2000;
  double smallRange =25000;
  double bigRange = 40000;



  double hWidth = (bigRange-smallRange)/hNum;

  TFile *fcalibration = new TFile(filename+".root");
  TH1D *calibration = new TH1D("calibration","calibration",hNum,smallRange,bigRange);
  TTree *tcalibration;
  fcalibration->GetObject("event",tcalibration);
  tcalibration->Draw("cal"+ ribbon + ">>calibration",condition,"COLZ"); 

 
  return calibration;
 
 }


EOA




  ijob=0
  while [ "$ijob" -le  "$filenumber" ]
  do



#------------------------------------------------
# create pedestalplot .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_pedestal_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/pedestal_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_pedestal_$ijob.sh
 

#------------------------------------------------
# create subtract_shifted .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_shifted_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_shifted_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_shifted_$ijob.sh




#------------------------------------------------
# create subtract_sum .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_sum_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_sum_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_sum_$ijob.sh




#------------------------------------------------
# create subtract_truncated .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_truncated_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_truncated_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_truncated_$ijob.sh




#------------------------------------------------
# create subtract_scaled .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_scaled_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_scaled_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_scaled_$ijob.sh



#------------------------------------------------
# create subtract_five .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_five_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_five_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_five_$ijob.sh




#------------------------------------------------
# create subtract_final .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_final_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_final_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_final_$ijob.sh














# the first part: condor 

#------------------------------------------------
# create  condor executable pedestal
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_pedestal.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_pedestal_$ijob
  echo now pedestal job_${ijob} start running 
EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_pedestal.sh





#------------------------------------------------
# create  condor executable subtract_shifted
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_shifted.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_shifted_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_shifted.sh



#------------------------------------------------
# create  condor executable subtract_sum
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_sum.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_sum_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_sum.sh





#------------------------------------------------
# create  condor executable subtract_truncated
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_truncated.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_truncated_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_truncated.sh



#------------------------------------------------
# create  condor executable subtract_scaled
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_scaled.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_scaled_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_scaled.sh





#------------------------------------------------
# create  condor executable subtract_five
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_five.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_five_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_five.sh





#------------------------------------------------
# create  condor executable subtract_final
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_final.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_final_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract_final.sh
















# the second part: executable jobs


#------------------------------------------------
# create pedestal executable jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_pedestal_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_pedestal_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_pedestal_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_pedestal_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_pedestal_$ijob.err
Queue

EOA





#------------------------------------------------
# create subtract_shifted executable subtract_shifted jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_shifted_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_shifted_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_shifted_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_shifted_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_shifted_$ijob.err
Queue

EOA




#------------------------------------------------
# create subtract_sum executable subtract_sum jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_sum_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_sum_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_sum_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_sum_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_sum_$ijob.err
Queue

EOA


#------------------------------------------------
# create subtract_truncated executable subtract_truncated jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_truncated_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_truncated_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_truncated_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_truncated_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_truncated_$ijob.err
Queue

EOA




#------------------------------------------------
# create subtract_scaled executable subtract_scaled jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_scaled_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_scaled_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_scaled_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_scaled_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_scaled_$ijob.err
Queue

EOA




#------------------------------------------------
# create subtract_five executable subtract_five jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_five_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_five_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_five_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_five_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_five_$ijob.err
Queue

EOA




#------------------------------------------------
# create subtract_final executable subtract_final jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_final_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_final_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_final_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_final_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_final_$ijob.err
Queue

EOA







# the third part
# it is the code below


#------------------------------------------------
# create pedestalplot code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/pedestal_$ijob.C <<-EOA


{
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include "pedestalmaterials.C"

  double hNum = 2000;
  double smallRange =25000;
  double bigRange = 40000;

  TString filename;
  char zhangname[1000];



 ifstream fin("/${MCDirectory}/${AnaDirectory}_$ijob"); 
 while( fin >> zhangname ) 
 {    
       
  TString fileribbon=Form(zhangname);
  double hWidth = (bigRange-smallRange)/hNum;


  TH1D *hist[2][10][100];
  TF1 *f[20][100][1000];

  double meanvalue;
  double value[2][10][100];
  double sigma[2][100][1000];

  ofstream out(fileribbon + "-fitting.txt");

if(out.is_open())
{

for(i=0;i<2;i++)
{
for(j=0;j<10;j++)
{
for(k=0;k<50;k++)
{

  hist[i][j][k] = pedestalmaterials(filename = fileribbon, ribbon = Form("[%d][%d][%d]", i,j,k), condition = Form("trig==160"));
  hist[i][j][k]->Fit("gaus");
  f[i][j][k] = hist[i][j][k]->GetFunction("gaus");
  value[i][j][k] = f[i][j][k]->GetParameter(1);
  sigma[i][j][k] = f[i][j][k]->GetParameter(2);
  out <<i <<" " << j << " " << k <<" "<< value[i][j][k] <<" "<< sigma[i][j][k] << endl;

}
}
} 


 
}

out.close();



}

}



EOA






#------------------------------------------------
# create subtract_shifted code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_shifted_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    
       
    TString fileribbon= Form(zhangname);
    TString fpath =Form( "%s-fitting.txt",zhangname);

    Geometry = fopen(fpath,"r") ;


    Float_t g;
    Int_t e1,e2,e3,e4,e5,k=0;
    Float_t geo[8][1000];



  char cbuf2[1000];

  while ( fgets(cbuf2, 1000, Geometry) != 0 ) 
 {
    if ( cbuf2[0] == '#' ) continue; 
    sscanf(cbuf2,"%i %i %i %f\n ",&e1,&e2,&e3,&g) ;


    geo[0][k]=e1;
    geo[1][k]=e2;
    geo[2][k]=e3;
    geo[3][k]=g;

//    cout <<geo[0][k] <<"   "<<geo[1][k] <<"  "<<geo[2][k] <<"  "<< geo[3][k] << endl;

    k++;

}



   fclose(Geometry);




   TFile fin(fileribbon + ".root","READ");
   TFile fout(fileribbon + "-shifted.root","recreate"); 
   TTree * event = (TTree *)fin.Get("event");   
   TTree * shiftedtree = new TTree ("shiftedtree", "shiftedtree");


      UInt_t  trig;
      double  cal[2][10][50];


      UInt_t  shiftedtrig;
      double  shiftedcal[2][10][50];


     event->SetBranchAddress("trig", &trig);
     event->SetBranchAddress("cal", &cal);
 

     shiftedtree->Branch("shiftedtrig",&shiftedtrig,"shiftedtrig/i");
     shiftedtree->Branch("shiftedcal",&shiftedcal,"shiftedcal[2][10][50]/D");



   int encal = event->GetEntries(); 

  for (long i=0; i< encal; ++i) 
 {
     event->GetEntry(i);

     shiftedtrig=trig;

    for(int l=0;l <2; l++) 
   {

    for(int m=0;m <10; m++) 
   {
 
    for(int n=0;n <50; n++) 
   {

      int num = l*50*10 + m*50 + n;
      shiftedcal[l][m][n] = cal[l][m][n] - geo[3][num];

    }   
    }
    }

   shiftedtree->Fill();

}


  fout->Write(); 
  fout.Close();
  fin.Close();



}

}

EOA






#------------------------------------------------
# create subtract_sum code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_sum_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    
       
    TString fileribbon= Form(zhangname);


 

   TFile fin(fileribbon + "-shifted.root","READ");
    TFile fout(fileribbon + "-sum.root","recreate");


    TTree * shiftedtree = (TTree *)fin.Get("shiftedtree"); 
    TTree * sumtree = new TTree ("sumtree", "sumtree");


   UInt_t  shiftedtrig;
   double  shiftedcal[2][10][50];

   UInt_t  sumtrig;
   double  sumcal[2][10][50];
   double  sumsinglecal[2][10][50];

   shiftedtree->SetBranchAddress("shiftedtrig", &shiftedtrig);
   shiftedtree->SetBranchAddress("shiftedcal", &shiftedcal);

   sumtree->Branch("sumtrig",&sumtrig,"sumtrig/i");
   sumtree->Branch("sumcal",&sumcal,"sumcal[2][10][50]/D");
   sumtree->Branch("sumsinglecal",&sumsinglecal,"sumsinglecal[2][10][50]/D");


  int encal = shiftedtree->GetEntries();

  for (long i=0; i< encal; ++i)
 {

     shiftedtree->GetEntry(i);
     sumtrig=shiftedtrig;



    for(int l=0;l <2; l++)
   {

    for(int m=0;m <10; m++)
   {

   for(int n=0;n <1; n++)
   {
     int num1 = l*50*10 + m*50 + n;
     int num2 = l*50*10 + m*50 + n+1;
     int num3 = l*50*10 + m*50 + n+2;
     sumcal[l][m][n] =  shiftedcal[l][m][n] +  shiftedcal[l][m][n+1] +  shiftedcal[l][m][n+2];
   }



   for(int n=1;n <2; n++)
    {
     sumcal[l][m][n] =  shiftedcal[l][m][n-1]  +  shiftedcal[l][m][n] + shiftedcal[l][m][n+1] + shiftedcal[l][m][n+2];
    }

   for(int n=48;n <49; n++)
    {
     sumcal[l][m][n] =  shiftedcal[l][m][n-2] +  shiftedcal[l][m][n-1] +  shiftedcal[l][m][n] + shiftedcal[l][m][n+1];
    }


   for(int n=49;n <50; n++)
    {
      sumcal[l][m][n] = shiftedcal[l][m][n-2]  +  shiftedcal[l][m][n-1]  +  shiftedcal[l][m][n];
    }


    for(int n=2;n <48; n++)
     {
      sumcal[l][m][n] = shiftedcal[l][m][n-2] + shiftedcal[l][m][n-1] + shiftedcal[l][m][n] + shiftedcal[l][m][n+1] + shiftedcal[l][m][n+2];
     }



     for(n=0;n<50; n++)
    {
     sumsinglecal[l][m][n] =  shiftedcal[l][m][n];
    }



    }
   }


   sumtree->Fill();

}



  fout->Write();
  fout.Close();
  fin.Close();



}

}

EOA







#------------------------------------------------
# create subtract_truncated code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_truncated_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    
       
    TString fileribbon= Form(zhangname);


    int evenposition=$even;
    int oddposition=$odd;
    double energycut=$cut;



    TFile fin(fileribbon + "-sum.root","READ");
    TFile fout(fileribbon + "-truncated.root","recreate");


    TTree * sumtree = (TTree *)fin.Get("sumtree"); 
    TTree * truncatedtree = new TTree ("truncatedtree", "truncatedtree");


   UInt_t  sumtrig;
   double  sumsinglecal[2][10][50];
   double  sumcal[2][10][50];

   UInt_t  truncatedtrig;
   double  truncatedsinglecal[2][10][50];
   double  truncatedsumcal[2][10][50];


  sumtree->SetBranchAddress("sumtrig", &sumtrig);
  sumtree->SetBranchAddress("sumsinglecal", &sumsinglecal);
  sumtree->SetBranchAddress("sumcal", &sumcal);


  truncatedtree->Branch("truncatedtrig",&truncatedtrig,"truncatedtrig/i");
  truncatedtree->Branch("truncatedsinglecal",&truncatedsinglecal,"truncatedsinglecal[2][10][50]/D");
  truncatedtree->Branch("truncatedsumcal",&truncatedsumcal,"truncatedsumcal[2][10][50]/D");

  int encal = sumtree->GetEntries();

  for (long i=0; i< encal; ++i)
 {



    sumtree->GetEntry(i);



//   if(sumcal[0][0][oddposition] > energycut)
  if(sumcal[0][0][oddposition] +sumcal[1][0][evenposition] > energycut)
{

   for(int n=0; n <50; n++)
   {

    truncatedtrig=sumtrig;


   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
 
    truncatedsinglecal[l][m][n] = sumsinglecal[l][m][n] ;
    truncatedsumcal[l][m][n] = sumcal[l][m][n] ;

   }
   }


  }


   truncatedtree->Fill();

}
}


  fout->Write();
  fout.Close();
  fin.Close();




}

}

EOA










#------------------------------------------------
# create subtract_scaled code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_scaled_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    



double datazhang[2][10][50]=
{
{

{109.968,    256.598,    159.125,    119.979,    163.547,    198.651,    193.439,    237.027,    186.238,    195.598,    202.649,    217.327,    170.942,    197.004,    214.102,    205.088,    192.199,    189.048,    186.647,    190.444,    165.794,    200.387,    174.794,    160.519,    199.027,    208.287,    190.106,    103.533,    162.09,     157.122,    191.498,    195.08,     196.716,    191.037,    135.433,    133.588,    196.82,     167.513,    194.789,    144.097,    174.799,    262.237,    196.638,    191.424,    137.528,    188.453,    201.346,    316.496,    208.925,    97.4395},

{423.973,    287.695,    278.601,    719.687,    541.785,    542.347,    636.682,    608.639,    357.869,    640.524,    604.777,    666.427,    559.482,    651.265,    593.583,    647.456,    295.752,    605.54,     673.997,    602.806,    557.273,    645.935,    427.959,    337.768,    322.943,    646.611,    568.674,    259.669,    602.022,    274.699,    581.096,    633.771,    637.621,    357.502,    320.548,    612.709,    654.394,    424.098,    613.19,     529.539,    681.903,    602.205,    635.586,    572.189,    681.854,    235.81,     519.838,    210.691,    604.243,    490.04},

{514.613,    408.452,    678.076,    147.768,    718.982,    355.373,    799.267,    360.899,    753.196,    267.572,    711.774,    387.454,    688.162,    352.108,    726.174,    300.39,     747.394,    396.741,    760.76,     413.748,    753.621,    251.405,    764.898,    308.409,    768.873,    355.706,    767.625,    350.402,    779.847,    345.04,     793.234,    313.211,    789.899,    259.263,    751.774,    333.184,    578.625,    324.894,    729.992,    349.174,    777.336,    384.156,    805.584,    360.157,    806.355,    297.543,    717.183,    255.512,    576.95,     301.387},

{638.853,    412.829,    396.865,    551.083,    421.646,    722.657,    626.446,    618.547,    575.254,    680.269,    627.41,     685.855,    620.313,    724.294,    736.365,    728.38,     637.49,     728.039,    653.898,    721.455,    687.612,    645.733,    686.666,    682.438,    700.835,    679.518,    666.929,    597.281,    440.892,    715.546,    725.877,    664.641,    627.132,    642.793,    657.652,    722.393,    578.419,    530.047,    739.587,    667.801,    676.197,    656.999,    547.837,    787.32,     492.441,    614.048,    414.203,    412.406,    667.188,    648.987},

{480.504,    354.274,    163.826,    379.153,    135.46,     620.699,    603.529,    424.671,    603.392,    583.024,    607.182,    610.191,    476.022,    483.982,    576.374,    496.234,    655.677,    555.49,     534.104,    515.691,    528.836,    488.793,    590.499,    415.335,    531.076,    414.496,    527.843,    455.068,    657.793,    539.867,    574.411,    536.663,    602.815,    459.69,     551.354,    509.73,     589.905,    582.873,    574.39,     563.622,    691.95,     591.886,    544.582,    516.079,    521.233,    407.438,    234.172,    284.684,    611.242,    112.018},

{204.681,    411.143,    309.385,    340.086,    410.882,    451.223,    490.325,    240.959,    443.755,    469.98,     387.405,    414.623,    407.321,    414.083,    551.742,    432.319,    464.904,    440.923,    402.688,    419.481,    503.62,     468.587,    465.407,    230.636,    465.285,    414.641,    415.341,    229.593,    517.157,    437.669,    493.903,    254.159,    438.887,    395.984,    437.154,    402.893,    461.941,    400.045,    552.008,    358.645,    523.046,    424.159,    498.086,    420.237,    502.197,    396.122,    269.202,    259.038,    264.326,    381.336},

{167.355,    345.675,    467.321,    361.545,    336.141,    754.978,    388.901,    793.269,    414.414,    782.264,    436.623,    747.747,    437.915,    836.474,    452.758,    694.898,    499.754,    717.92,     404.251,    776.829,    418.135,    721.126,    177.381,    718.156,    424.191,    754.411,    427.339,    704.975,    472.333,    670.059,    403.42,     663.897,    407.093,    709.843,    425.325,    622.591,    436.656,    802.865,    252.138,    657.541,    172.116,    679.577,    412.885,    606.377,    173.067,    195.273,    452.688,    281.463,    346.037,    405.661},

{296.436,    596.192,    185.536,    361.545,    336.141,    756.097,    388.901,    800.783,    414.414,    786.93,     436.623,    755.897,    437.915,    838.85,     452.758,    703.891,    499.754,    721.578,    404.251,    781.871,    418.135,    684.073,    194.685,    726.385,    424.191,    756.294,    427.339,    700.985,    472.333,    682.866,    403.42,     668.58,     407.093,    710.928,    425.325,    622.591,    436.656,    807.018,    252.138,    658.583,    199.551,    681.423,    412.885,    606.377,    184.328,    218.897,    452.688,    281.463,    346.037,    405.661},


{243.577,    478.019,    430.139,    197.984,    434.802,    576.395,    500.969,    642.886,    495.853,    563.145,    530.3,  374.01,     532.1,  636.767,    592.037,    552.649,    166.989,    556.349,    582.717,    582.717,    482.996,    395.372,    573.045,    428.644,    612.163,    437.026,    538.701,    371.807,    560.898,    442.782,    550.052,    523.658,    292.318,    529.43,     518.243,    527.337,    585.616,    441.019,    493,    467.3,  339.48,     543.685,    227.723,    461.242,    395.854,    437.003,    465.095,    281.574,    137.724,    314.769},


{125.061,    227.823,    20.5067,    64.0205,    14.292,     313.754,    205.167,    293.193,    201.476,    269.821,    272.898,    96.3309,    314.685,    353.935,    270.185,    339.458,    203.163,    237.982,    164.733,    164.733,    272.984,    222.978,    254.23,     215.135,    222.42,     184.34,     250.419,    349.413,    338.236,    284.054,    277.936,    212.659,    179.255,    261.521,    265.416,    294.366,    197.357,    279.221,    274.301,    340.779,    169.083,    353.676,    250.634,    324.05,     261.671,    397.343,    236.969,    76.373,     69.593,     127.512},

},


{

{198.514,    478.012,    214.194,    456.38,     258.548,    501.492,    243.431,    528.93,     250.265,    533.757,    248.878,    497.583,    244.835,    501.932,    305.357,    515.552,    271.66,     464.867,    351.774,    584.059,    333.39,     550.012,    213.08,     538.712,    350.374,    486.784,    135.793,    538.507,    119.713,    400.582,    211.74,     495.367,    258.624,    538.169,    312.74,     567.485,    217.152,    469.549,    338.429,    400.356,    338.113,    539.73,     327.724,    538.03,     299.365,    529.809,    249.651,    523.075,    128.439,    201.331},

{401.047,    21.7715,    278.206,    14.8091,    428.704,    704.51,     430.355,    645.936,    448.677,    642.969,    605.301,    580.937,    445.903,    743.442,    571.345,    611.854,    542.504,    677.913,    568.512,    769.718,    610.089,    633.822,    668.561,    638.069,    646.059,    601.929,    379.806,    642.246,    573.856,    610.346,    546.964,    713.309,    391.033,    627.163,    639.861,    563.79,     633.74,     412.235,    639.398,    569.541,    112.923,    26.5777,    656.052,    20.9292,    378.837,    441.531,    314.186,    401.284,    329.844,    56.184},


{417.005,    535.185,    588.877,    462.355,    541.98,     629.512,    619.563,    580.522,    511.031,    661.131,    526.769,    622.051,    582.259,    641.51,     583.554,    694.723,    578.572,    635.215,    581.013,    588.371,    548.368,    576.164,    608.085,    685.634,    578.328,    555.511,    588.617,    455.634,    610.786,    557.302,    599.127,    583.653,    616.741,    615.155,    648.477,    506.389,    534.145,    664.138,    584.622,    460.119,    593.205,    608.026,    529.231,    611.038,    487.38,     515.278,    530.717,    614.331,    570.396,    555.828},


{440.667,    402.787,    360.117,    569.666,    500.607,    622.959,    603.338,    670.601,    430.604,    629.769,    617.082,    702.608,    526.645,    761.5,  495.447,    542.555,    603.398,    650.107,    648.501,    658.277,    493.896,    635.55,     560.541,    590.051,    615.988,    406.474,    629.193,    605.784,    589.903,    581.509,    527.265,    678.226,    571.082,    558.418,    669.294,    587.224,    555.617,    686.823,    644.314,    629.373,    608.63,     624.89,     626.351,    612.856,    592.33,     721.887,    575.996,    661.065,    516.371,    333.164},


{319.539,    19.7605,    304.622,    319.952,    335.676,    611.816,    539.41,     617.576,    524.008,    587.68,     530.509,    586.438,    534.555,    496.009,    510.983,    611.981,    604.894,    565.364,    551.579,    468.337,    503.902,    612.38,     536.497,    634.89,     539.746,    553.149,    539.993,    609.391,    510.104,    510.701,    590.093,    589.378,    468.426,    504.265,    501.629,    527.655,    600.934,    551.033,    521.531,    518.31,     566.411,    560.836,    579.636,    574.285,    498.325,    14.8568,    405.329,    19.2878,    512.285,    225.843},


{278.37,     157.992,    384.281,    119.864,    363.764,    679.785,    539.982,    624.826,    590.049,    666.377,    605.328,    690.911,    523.883,    439.877,    512.272,    671.599,    522.365,    611.498,    515.131,    644.993,    474.864,    617.266,    402.551,    584.104,    472.566,    618.832,    542.846,    747.214,    536.931,    646.106,    584.038,    702.282,    569.066,    703.806,    605.905,    644.989,    329.922,    713.552,    383.975,    625.476,    559.037,    694.506,    487.91,     592.032,    538.938,    302.943,    536.052,    685.699,    350.677,    385.057},


{163.442,    400.205,    316.313,    574.06,     357.512,    596.386,    483.136,    751.461,    622.036,    794.624,    296.208,    647.435,    526.899,    729.036,    603.723,    744.377,    634.311,    673.221,    709.797,    567.066,    633.225,    448.638,    542.591,    755.576,    390.14,     724.802,    606.417,    691.018,    638.264,    805.825,    616.402,    770.686,    644.369,    643.455,    582.918,    626.281,    628.386,    724.15,     308.737,    814.513,    247.391,    869.453,    690.106,    727.311,    552.349,    712.435,    457.876,    350.119,    408.922,    277.292},


{422.428,    405.035,    361.463,    399.311,    398.519,    449.899,    543.628,    440.934,    416.212,    435.749,    408.281,    544.644,    111.88,     492.469,    442.264,    516.549,    424.34,     478.482,    477.072,    267.209,    498.016,    537.848,    548.235,    479.082,    529.296,    595.252,    273.356,    508.243,    480.272,    485.496,    508.459,    332.508,    542.969,    468.867,    440.349,    468.905,    436.405,    452.176,    485.207,    411.366,    480.345,    425.645,    380.337,    413.94,     539.474,    398.64,     322.198,    408.931,    383.938,    294.083},


{300,    200.183,    250.719,    300.828,    425.197,    265.811,    543.443,    290.642,    454.99,     446.772,    394.965,    437.084,    458.362,    435.169,    499.222,    538.902,    527.236,    567,    531.343,    454.52,     410.604,    216.155,    407.761,    404.449,    596.028,    619.852,    455.064,    542.96,     561.039,    525.199,    504.845,    468.24,     486.768,    439.172,    564.216,    448.455,    528.342,    512.791,    417.803,    467.32,     517.52,     515.435,    561.849,    433.343,    344.344,    356.474,    376.615,    308.584,    513.903,    343.768},


{75.4846,    70.0737,    63.887,     87.7222,    56.5654,    110.744,    94.6623,    134.412,    112.097,    122.122,    91.6899,    120.529,    102.685,    130.413,    111.355,    108.909,    85.4411,    98.453,     104.995,    128.938,    100.565,    131.643,    110.035,    85.3359,    110.597,    132.855,    48.8661,    118.132,    108.601,    99.3591,    59.4442,    106.615,    95.7014,    113.53,     95.4532,    113.359,    92.0029,    104.256,    99.8014,    125.337,    105.48,     105.597,    109.723,    101.195,    80.3125,    97.5116,    96.1972,    77.6694,    104.831,    39.4051}


}

};
















double datamix[2][10][50]=
{
{
{109.968,    256.598,    159.125,    119.979,    163.547,    198.651,    193.439,    237.027,    186.238,    195.598,    202.649,    217.327,    170.942,    197.004,    214.102,    205.088,    192.199,    189.048,    186.647,    190.444,    165.794,    200.387,    174.794,    160.519,    199.027,    208.287,    190.106,    103.533,    162.09,     157.122,    191.498,    195.08,     196.716,    191.037,    135.433,    133.588,    196.82,     167.513,    194.789,    144.097,    174.799,    262.237,    196.638,    191.424,    137.528,    188.453,    201.346,    316.496,    208.925,    97.4395},

{423.973,    287.695,    278.601,    719.687,    541.785,    542.347,    636.682,    608.639,    357.869,    640.524,    604.777,    666.427,    559.482,    651.265,    593.583,    647.456,    295.752,    605.54,     673.997,    602.806,    557.273,    645.935,    427.959,    337.768,    322.943,    646.611,    568.674,    259.669,    602.022,    274.699,    581.096,    633.771,    637.621,    357.502,    320.548,    612.709,    654.394,    424.098,    613.19,     529.539,    681.903,    602.205,    635.586,    572.189,    681.854,    235.81,     519.838,    210.691,    604.243,    490.04},

{514.613,    408.452,    678.076,    147.768,    718.982,    355.373,    799.267,    360.899,    753.196,    267.572,    711.774,    387.454,    688.162,    352.108,    726.174,    300.39,     747.394,    396.741,    760.76,     413.748,    753.621,    251.405,    764.898,    308.409,    768.873,    355.706,    767.625,    350.402,    779.847,    345.04,     793.234,    313.211,    789.899,    259.263,    751.774,    333.184,    578.625,    324.894,    729.992,    349.174,    777.336,    384.156,    805.584,    360.157,    806.355,    297.543,    717.183,    255.512,    576.95,     301.387},

{638.853,    412.829,    396.865,    551.083,    421.646,    722.657,    626.446,    618.547,    575.254,    680.269,    627.41,     685.855,    620.313,    724.294,    736.365,    728.38,     637.49,     728.039,    653.898,    721.455,    687.612,    645.733,    686.666,    682.438,    700.835,    679.518,    666.929,    597.281,    440.892,    715.546,    725.877,    664.641,    627.132,    642.793,    657.652,    722.393,    578.419,    530.047,    739.587,    667.801,    676.197,    656.999,    547.837,    787.32,     492.441,    614.048,    414.203,    412.406,    667.188,    648.987},

{480.504,    354.274,    163.826,    379.153,    135.46,     620.699,    603.529,    424.671,    603.392,    583.024,    607.182,    610.191,    476.022,    483.982,    576.374,    496.234,    655.677,    555.49,     534.104,    515.691,    528.836,    488.793,    590.499,    415.335,    531.076,    414.496,    527.843,    455.068,    657.793,    539.867,    574.411,    536.663,    602.815,    459.69,     551.354,    509.73,     589.905,    582.873,    574.39,     563.622,    691.95,     591.886,    544.582,    516.079,    521.233,    407.438,    234.172,    284.684,    611.242,    112.018},

{169.291,    351.512,    320.129,    263.325,    341.286,    392.309,    408.651,    198.528,    400.235,    385.004,    336.421,    344.902,    375.974,    322.954,    487.223,    343.588,    406.355,    357.87,     372.141,    343.688,    455.308,    393.638,    425.716,    163.518,    429.599,    345.12,     400.851,    202.833,    462.206,    373.668,    442.794,    228.636,    326.222,    331.658,    368.318,    349.306,    430.547,    330.305,    480.575,    310.149,    479.534,    352.584,    451.034,    352.955,    452.784,    339.708,    231.035,    223.542,    217.574,    307.786},

{114.842,    226.161,    78.3745,    153.595,    134.169,    284.731,    149.808,    290.02,     165.532,    309.84,     175.642,    288.196,    182.635,    313.693,    191.298,    268.074,    212.237,    280.385,    163.707,    357.392,    172.591,    293.096,    92.223,     291.308,    175.77,     293.849,    180.649,    295.771,    209.877,    321.331,    178.853,    263.576,    169.353,    274.954,    168.348,    264.061,    176.777,    306.145,    105.035,    274.224,    87.22,  256.703,    175.509,    233.653,    83.1002,    88.399,     177.012,    117.373,    132.916,    165.805},

{270.637,    433.894,    155.714,    427.101,    189.022,    475.026,    323.161,    430.949,    360.432,    512.018,    423.735,    378.106,    315.252,    456.271,    371.936,    484.56,     335.534,    425.371,    238.611,    238.611,    227.599,    481.89,     263.287,    544.384,    335.243,    362.729,    323.426,    427.402,    435.708,    541.902,    330.165,    423.882,    343.804,    405.475,    287.299,    434.821,    353.933,    438.121,    334.697,    357.334,    433.345,    481.778,    370.101,    463.75,     331.523,    369.386,    341.638,    289.375,    345.318,    440.799},

{243.577,    478.019,    430.139,    197.984,    434.802,    576.395,    500.969,    642.886,    495.853,    563.145,    530.3,  374.01,     532.1,  636.767,    592.037,    552.649,    166.989,    556.349,    582.717,    582.717,    482.996,    395.372,    573.045,    428.644,    612.163,    437.026,    538.701,    371.807,    560.898,    442.782,    550.052,    523.658,    292.318,    529.43,     518.243,    527.337,    585.616,    441.019,    493,    467.3,  339.48,     543.685,    227.723,    461.242,    395.854,    437.003,    465.095,    281.574,    137.724,    314.769},

{125.061,    227.823,    20.5067,    64.0205,    14.292,     313.754,    205.167,    293.193,    201.476,    269.821,    272.898,    96.3309,    314.685,    353.935,    270.185,    339.458,    203.163,    237.982,    164.733,    164.733,    272.984,    222.978,    254.23,     215.135,    222.42,     184.34,     250.419,    349.413,    338.236,    284.054,    277.936,    212.659,    179.255,    261.521,    265.416,    294.366,    197.357,    279.221,    274.301,    340.779,    169.083,    353.676,    250.634,    324.05,     261.671,    397.343,    236.969,    76.373,     69.593,     127.512},

},

{

{198.514,    478.012,    214.194,    456.38,     258.548,    501.492,    243.431,    528.93,     250.265,    533.757,    248.878,    497.583,    244.835,    501.932,    305.357,    515.552,    271.66,     464.867,    351.774,    584.059,    333.39,     550.012,    213.08,     538.712,    350.374,    486.784,    135.793,    538.507,    119.713,    400.582,    211.74,     495.367,    258.624,    538.169,    312.74,     567.485,    217.152,    469.549,    338.429,    400.356,    338.113,    539.73,     327.724,    538.03,     299.365,    529.809,    249.651,    523.075,    128.439,    201.331},

{401.047,    21.7715,    278.206,    14.8091,    428.704,    704.51,     430.355,    645.936,    448.677,    642.969,    605.301,    580.937,    445.903,    743.442,    571.345,    611.854,    542.504,    677.913,    568.512,    769.718,    610.089,    633.822,    668.561,    638.069,    646.059,    601.929,    379.806,    642.246,    573.856,    610.346,    546.964,    713.309,    391.033,    627.163,    639.861,    563.79,     633.74,     412.235,    639.398,    569.541,    112.923,    26.5777,    656.052,    20.9292,    378.837,    441.531,    314.186,    401.284,    329.844,    56.184},

{417.005,    535.185,    588.877,    462.355,    541.98,     629.512,    619.563,    580.522,    511.031,    661.131,    526.769,    622.051,    582.259,    641.51,     583.554,    694.723,    578.572,    635.215,    581.013,    588.371,    548.368,    576.164,    608.085,    685.634,    578.328,    555.511,    588.617,    455.634,    610.786,    557.302,    599.127,    583.653,    616.741,    615.155,    648.477,    506.389,    534.145,    664.138,    584.622,    460.119,    593.205,    608.026,    529.231,    611.038,    487.38,     515.278,    530.717,    614.331,    570.396,    555.828},

{440.667,    402.787,    360.117,    569.666,    500.607,    622.959,    603.338,    670.601,    430.604,    629.769,    617.082,    702.608,    526.645,    761.5,  495.447,    542.555,    603.398,    650.107,    648.501,    658.277,    493.896,    635.55,     560.541,    590.051,    615.988,    406.474,    629.193,    605.784,    589.903,    581.509,    527.265,    678.226,    571.082,    558.418,    669.294,    587.224,    555.617,    686.823,    644.314,    629.373,    608.63,     624.89,     626.351,    612.856,    592.33,     721.887,    575.996,    661.065,    516.371,    333.164},

{319.539,    19.7605,    304.622,    319.952,    335.676,    611.816,    539.41,     617.576,    524.008,    587.68,     530.509,    586.438,    534.555,    496.009,    510.983,    611.981,    604.894,    565.364,    551.579,    468.337,    503.902,    612.38,     536.497,    634.89,     539.746,    553.149,    539.993,    609.391,    510.104,    510.701,    590.093,    589.378,    468.426,    504.265,    501.629,    527.655,    600.934,    551.033,    521.531,    518.31,     566.411,    560.836,    579.636,    574.285,    498.325,    14.8568,    405.329,    19.2878,    512.285,    225.843},

{140.095,    84.1645,    192.262,    61.1118,    145.334,    346.139,    281.87,     345.125,    308.03,     341.565,    328.346,    357.806,    281.593,    256.329,    272.485,    349.522,    280.856,    316.928,    280.101,    343.52,     245.869,    325.081,    250.726,    274.025,    291.179,    334.826,    287.965,    376.106,    284.346,    337.554,    300.041,    343.224,    282.656,    375.04,     312.15,     322.786,    177.657,    383.283,    209.807,    319.29,     267.199,    348.557,    252.2,  344.471,    273.941,    138.242,    272.54,     363.854,    201.538,    214.989},

{200.175,    123.512,    24.1964,    345.974,    194.17,     347.661,    269.303,    429.302,    306.127,    465.575,    118.711,    399.594,    268.927,    381.566,    347.514,    414.213,    350.297,    427.974,    476.695,    295.346,    239.562,    171.207,    197.466,    448.411,    145.245,    451.317,    314.326,    416.836,    380.173,    490.418,    359.27,     450.486,    380.078,    395.507,    321.488,    381.213,    349.095,    510.185,    117.756,    503.231,    89.6988,    505.926,    403.422,    436.867,    313.007,    428.718,    235.707,    225.101,    256.996,    238.195},

{408.713,    306.055,    346.887,    371.564,    348.618,    456.318,    514.966,    430.09,     394.416,    412.25,     406.627,    549.109,    77.9868,    448.738,    429.333,    485.676,    399.361,    503.121,    475.921,    217.354,    412.084,    507.692,    460.731,    466.809,    474.406,    591.221,    237.881,    493.695,    461.329,    478.699,    490.291,    318.114,    544.326,    462.079,    431.917,    463.518,    438.024,    465.348,    424.432,    322.072,    472.52,     410.686,    328.745,    405.38,     527.271,    351.769,    335.07,     416.272,    424.927,    193.046},

{300,    200.183,    250.719,    300.828,    425.197,    265.811,    543.443,    290.642,    454.99,     446.772,    394.965,    437.084,    458.362,    435.169,    499.222,    538.902,    527.236,    567,    531.343,    454.52,     410.604,    216.155,    407.761,    404.449,    596.028,    619.852,    455.064,    542.96,     561.039,    525.199,    504.845,    468.24,     486.768,    439.172,    564.216,    448.455,    528.342,    512.791,    417.803,    467.32,     517.52,     515.435,    561.849,    433.343,    344.344,    356.474,    376.615,    308.584,    513.903,    343.768},


{75.4846,    70.0737,    63.887,     87.7222,    56.5654,    110.744,    94.6623,    134.412,    112.097,    122.122,    91.6899,    120.529,    102.685,    130.413,    111.355,    108.909,    85.4411,    98.453,     104.995,    128.938,    100.565,    131.643,    110.035,    85.3359,    110.597,    132.855,    48.8661,    118.132,    108.601,    99.3591,    59.4442,    106.615,    95.7014,    113.53,     95.4532,    113.359,    92.0029,    104.256,    99.8014,    125.337,    105.48,     105.597,    109.723,    101.195,    80.3125,    97.5116,    96.1972,    77.6694,    104.831,    39.405}



}




};












double datahan[2][10][50]=
{
{
{109.968,    256.598,    159.125,    119.979,    163.547,    198.651,    193.439,    237.027,    186.238,    195.598,    202.649,    217.327,    170.942,    197.004,    214.102,    205.088,    192.199,    189.048,    186.647,    190.444,    165.794,    200.387,    174.794,    160.519,    199.027,    208.287,    190.106,    103.533,    162.09,     157.122,    191.498,    195.08,     196.716,    191.037,    135.433,    133.588,    196.82,     167.513,    194.789,    144.097,    174.799,    262.237,    196.638,    191.424,    137.528,    188.453,    201.346,    316.496,    208.925,    97.4395},

{423.973,    287.695,    278.601,    719.687,    541.785,    542.347,    636.682,    608.639,    357.869,    640.524,    604.777,    666.427,    559.482,    651.265,    593.583,    647.456,    295.752,    605.54,     673.997,    602.806,    557.273,    645.935,    427.959,    337.768,    322.943,    646.611,    568.674,    259.669,    602.022,    274.699,    581.096,    633.771,    637.621,    357.502,    320.548,    612.709,    654.394,    424.098,    613.19,     529.539,    681.903,    602.205,    635.586,    572.189,    681.854,    235.81,     519.838,    210.691,    604.243,    490.04},


{514.613,    408.452,    678.076,    147.768,    718.982,    355.373,    799.267,    360.899,    753.196,    267.572,    711.774,    387.454,    688.162,    352.108,    726.174,    300.39,     747.394,    396.741,    760.76,     413.748,    753.621,    251.405,    764.898,    308.409,    768.873,    355.706,    767.625,    350.402,    779.847,    345.04,     793.234,    313.211,    789.899,    259.263,    751.774,    333.184,    578.625,    324.894,    729.992,    349.174,    777.336,    384.156,    805.584,    360.157,    806.355,    297.543,    717.183,    255.512,    576.95,     301.387},


{638.853,    412.829,    396.865,    551.083,    421.646,    722.657,    626.446,    618.547,    575.254,    680.269,    627.41,     685.855,    620.313,    724.294,    736.365,    728.38,     637.49,     728.039,    653.898,    721.455,    687.612,    645.733,    686.666,    682.438,    700.835,    679.518,    666.929,    597.281,    440.892,    715.546,    725.877,    664.641,    627.132,    642.793,    657.652,    722.393,    578.419,    530.047,    739.587,    667.801,    676.197,    656.999,    547.837,    787.32,     492.441,    614.048,    414.203,    412.406,    667.188,    648.987},


{480.504,    354.274,    163.826,    379.153,    135.46,     620.699,    603.529,    424.671,    603.392,    583.024,    607.182,    610.191,    476.022,    483.982,    576.374,    496.234,    655.677,    555.49,     534.104,    515.691,    528.836,    488.793,    590.499,    415.335,    531.076,    414.496,    527.843,    455.068,    657.793,    539.867,    574.411,    536.663,    602.815,    459.69,     551.354,    509.73,     589.905,    582.873,    574.39,     563.622,    691.95,     591.886,    544.582,    516.079,    521.233,    407.438,    234.172,    284.684,    611.242,    112.018},


{204.681,    411.143,    309.385,    340.086,    410.882,    451.223,    490.325,    240.959,    443.755,    469.98,     387.405,    414.623,    407.321,    414.083,    551.742,    432.319,    464.904,    440.923,    402.688,    419.481,    503.62,     468.587,    465.407,    230.636,    465.285,    414.641,    415.341,    229.593,    517.157,    437.669,    493.903,    254.159,    438.887,    395.984,    437.154,    402.893,    461.941,    400.045,    552.008,    358.645,    523.046,    424.159,    498.086,    420.237,    502.197,    396.122,    269.202,    259.038,    264.326,    381.336},


{167.355,    167.355,    167.355,    361.545,    336.141,    754.978,    388.901,    793.269,    414.414,    782.264,    436.623,    747.747,    437.915,    836.474,    452.758,    694.898,    499.754,    717.92,     404.251,    776.829,    418.135,    721.126,    177.381,    718.156,    424.191,    754.411,    427.339,    704.975,    472.333,    670.059,    403.42,     663.897,    407.093,    709.843,    425.325,    622.591,    436.656,    802.865,    252.138,    657.541,    172.116,    679.577,    412.885,    606.377,    173.067,    195.273,    452.688,    281.463,    346.037,    405.661},


{296.436,    596.192,    185.536,    361.545,    336.141,    756.097,    388.901,    800.783,    414.414,    786.93,     436.623,    755.897,    437.915,    838.85,     452.758,    703.891,    499.754,    721.578,    404.251,    781.871,    418.135,    684.073,    194.685,    726.385,    424.191,    756.294,    427.339,    700.985,    472.333,    682.866,    403.42,     668.58,     407.093,    710.928,    425.325,    622.591,    436.656,    807.018,    252.138,    658.583,    199.551,    681.423,    412.885,    606.377,    184.328,    218.897,    452.688,    281.463,    346.037,    405.661},


{243.577,    478.019,    430.139,    197.984,    434.802,    576.395,    500.969,    642.886,    495.853,    563.145,    530.3,  374.01,     532.1,  636.767,    592.037,    552.649,    166.989,    556.349,    582.717,    582.717,    482.996,    395.372,    573.045,    428.644,    612.163,    437.026,    538.701,    371.807,    560.898,    442.782,    550.052,    523.658,    292.318,    529.43,     518.243,    527.337,    585.616,    441.019,    493,    467.3,  339.48,     543.685,    227.723,    461.242,    395.854,    437.003,    465.095,    281.574,    137.724,    314.769},


{125.061,    227.823,    20.5067,    64.0205,    14.292,     313.754,    205.167,    293.193,    201.476,    269.821,    272.898,    96.3309,    314.685,    353.935,    270.185,    339.458,    203.163,    237.982,    164.733,    164.733,    272.984,    222.978,    254.23,     215.135,    222.42,     184.34,     250.419,    349.413,    338.236,    284.054,    277.936,    212.659,    179.255,    261.521,    265.416,    294.366,    197.357,    279.221,    274.301,    340.779,    169.083,    353.676,    250.634,    324.05,     261.671,    397.343,    236.969,    76.373,     69.593,     127.512}

},

{
{198.514 ,   478.012 ,   214.194 ,   456.38 ,    258.548 ,   501.492 ,   243.431 ,   528.93 ,    250.265 ,   533.757 ,   248.878 ,   497.583 ,   244.835 ,   501.932 ,   305.357 ,   515.552 ,   271.66 ,    464.867 ,   351.774 ,   584.059 ,   333.39 ,    550.012 ,   213.08 ,    538.712 ,   350.374 ,   486.784 ,   135.793 ,   538.507 ,   119.713 ,   400.582 ,   211.74 ,    495.367 ,   258.624 ,   538.169 ,   312.74 ,    567.485 ,   217.152 ,   18.4966 ,   338.429 ,   400.356 ,   338.113 ,   539.73 ,    327.724 ,   538.03 ,    299.365 ,   529.809 ,   249.651 ,   523.075 ,   128.439 ,   201.331 },

{401.047 ,   21.7715 ,   278.206 ,   14.8091 ,   428.704 ,   704.51 ,    430.355 ,   645.936 ,   448.677 ,   642.969 ,   605.301 ,   580.937 ,   445.903 ,   743.442 ,   571.345 ,   611.854 ,   542.504 ,   677.913 ,   568.512 ,   769.718 ,   610.089 ,   633.822 ,   668.561 ,   638.069 ,   646.059 ,   601.929 ,   379.806 ,   642.246 ,   573.856 ,   610.346 ,   546.964 ,   713.309 ,   391.033 ,   627.163 ,   639.861 ,   563.79 ,    633.74 ,    10.3135 ,   639.398 ,   569.541 ,   112.923 ,   26.5777 ,   656.052 ,   20.9292 ,   378.837 ,   441.531 ,   314.186 ,   401.284 ,   329.844 ,   56.184 },

{417.005 ,   535.185 ,   588.877 ,   462.355 ,   541.98 ,    629.512 ,   619.563 ,   580.522 ,   511.031 ,   661.131 ,   526.769 ,   622.051 ,   582.259 ,   641.51 ,    583.554 ,   694.723 ,   578.572 ,   635.215 ,   581.013 ,   588.371 ,   548.368 ,   576.164 ,   608.085 ,   685.634 ,   578.328 ,   555.511 ,   588.617 ,   455.634 ,   610.786 ,   557.302 ,   599.127 ,   583.653 ,   616.741 ,   615.155 ,   648.477 ,   506.389 ,   534.145 ,   664.138 ,   584.622 ,   460.119 ,   593.205 ,   608.026 ,   529.231 ,   611.038 ,   487.38 ,    515.278 ,   530.717 ,   614.331 ,   570.396 ,   555.828 },

{440.667 ,   402.787 ,   360.117 ,   569.666 ,   500.607 ,   622.959 ,   603.338 ,   670.601 ,   430.604 ,   629.769 ,   617.082 ,   702.608 ,   526.645 ,   761.5 , 495.447 ,   542.555 ,   603.398 ,   650.107 ,   648.501 ,   658.277 ,   493.896 ,   635.55 ,    560.541 ,   590.051 ,   615.988 ,   406.474 ,   629.193 ,   605.784 ,   589.903 ,   581.509 ,   527.265 ,   678.226 ,   571.082 ,   558.418 ,   669.294 ,   587.224 ,   555.617 ,   686.823 ,   644.314 ,   629.373 ,   608.63 ,    624.89 ,    626.351 ,   612.856 ,   592.33 ,    721.887 ,   575.996 ,   661.065 ,   516.371 ,   333.164 },

{319.539 ,   19.7605 ,   304.622 ,   319.952 ,   335.676 ,   611.816 ,   539.41 ,    617.576 ,   524.008 ,   587.68 ,    530.509 ,   586.438 ,   534.555 ,   496.009 ,   510.983 ,   611.981 ,   604.894 ,   565.364 ,   551.579 ,   468.337 ,   503.902 ,   612.38 ,    536.497 ,   634.89 ,    539.746 ,   553.149 ,   539.993 ,   609.391 ,   510.104 ,   510.701 ,   590.093 ,   589.378 ,   468.426 ,   504.265 ,   501.629 ,   527.655 ,   600.934 ,   551.033 ,   521.531 ,   518.31 ,    566.411 ,   560.836 ,   579.636 ,   574.285 ,   498.325 ,   14.8568 ,   405.329 ,   19.2878 ,   512.285 ,   225.843 },

{278.37 ,    157.992 ,   384.281 ,   119.864 ,   363.764 ,   679.785 ,   539.982 ,   624.826 ,   590.049 ,   666.377 ,   605.328 ,   690.911 ,   523.883 ,   439.877 ,   512.272 ,   671.599 ,   522.365 ,   611.498 ,   515.131 ,   644.993 ,   474.864 ,   617.266 ,   402.551 ,   584.104 ,   472.566 ,   618.832 ,   542.846 ,   747.214 ,   536.931 ,   646.106 ,   584.038 ,   702.282 ,   569.066 ,   703.806 ,   605.905 ,   644.989 ,   329.922 ,   713.552 ,   383.975 ,   625.476 ,   559.037 ,   694.506 ,   487.91 ,    592.032 ,   538.938 ,   302.943 ,   536.052 ,   685.699 ,   350.677 ,   385.057 },

{163.442 ,   400.205 ,   316.313 ,   574.06 ,    357.512 ,   596.386 ,   483.136 ,   751.461 ,   622.036 ,   794.624 ,   296.208 ,   647.435 ,   526.899 ,   729.036 ,   603.723 ,   744.377 ,   634.311 ,   673.221 ,   709.797 ,   567.066 ,   633.225 ,   448.638 ,   542.591 ,   755.576 ,   390.14 ,    724.802 ,   606.417 ,   691.018 ,   638.264 ,   805.825 ,   616.402 ,   770.686 ,   644.369 ,   643.455 ,   582.918 ,   626.281 ,   628.386 ,   724.15 ,    308.737 ,   814.513 ,   247.391 ,   869.453 ,   690.106 ,   727.311 ,   552.349 ,   712.435 ,   457.876 ,   350.119 ,   408.922 ,   277.292 },

{350.827 ,   235.8816 ,  206.195 ,   466.971 ,   377.209 ,   556.715 ,   534.351 ,   460.421 ,   437.348 ,   500.443 ,   429.824 ,   655.814 ,   81.3053 ,   559.759 ,   444.807 ,   635.329 ,   407.138 ,   591.267 ,   501.797 ,   230.804 ,   498.261 ,   531.068 ,   513.334 ,   638.399 ,   6.77502 ,   720.114 ,   326.416 ,   611.6 , 476.477 ,   538.287 ,   555.427 ,   475.562 ,   551.012 ,   567.963 ,   479.903 ,   501.299 ,   497.185 ,   562.399 ,   485.033 ,   216.723 ,   547.534 ,   304.598 ,   441.73 ,    0.00397302 ,    0.377226 ,  0.304611 ,  -0.531211 , 1.18486 ,   1.424 , -1.36608 },

{185.182 ,   26.8412 ,   363.953 ,   215.997 ,   486.62 ,    210.703 ,   651.108 ,   316.068 ,   543.403 ,   470.702 ,   450.338 ,   488.827 ,   577.535 ,   462.339 ,   533.424 ,   587.6 , 559.243 ,   589.911 ,   546.356 ,   542.519 ,   503.684 ,   231.514 ,   498.162 ,   449.896 ,   6.50995 ,   685.757 ,   522.721 ,   578.728 ,   615.744 ,   571.774 ,   565.269 ,   516.668 ,   559.225 ,   469.942 ,   628.863 ,   506.137 ,   580.891 ,   609.318 ,   457.802 ,   509.675 ,   608.953 ,   529.187 ,   627.798 ,   0.465817 ,  0.163685 ,  0.882157 ,  0.732599 ,  1.29294 ,   0.405828 ,  0.610458 },

{65.7592 ,   75.1214 ,   79.2032 ,   106.972 ,   86.2354 ,   123.782 ,   123.729 ,   145.251 ,   131.751 ,   135.004 ,   125.938 ,   137.785 ,   135.212 ,   142.15 ,    150.621 ,   118.677 ,   119.539 ,   102.947 ,   144.103 ,   140.042 ,   134.264 ,   142.797 ,   144.35 ,    85.897 ,    11.4217 ,   146.842 ,   65.0658 ,   118.833 ,   142.229 ,   106.609 ,   78.559 ,    111.365 ,   127.576 ,   117.314 ,   119.649 ,   118.282 ,   118.359 ,   120.495 ,   120.005 ,   130.434 ,   142.601 ,   102.056 ,   145.578 ,   2.7868 ,    0.191439 ,  1.67819 ,   1.31178 ,   1.00928 ,   0.0291559 , 0.0363322 }

}


};






double mchan[2][10]=
{
{15.1141,38.8958,46.2024,54.8702,48.2967,35.0921,18.681,33.1653,37.9474,22},
{32.7207,39.6409,52.6833,53.0111,42.1056,27.9933,25.6728,37.9893,31.5163,10}
};


double mcmix[2][10]=
{
{15.1141,38.8958,46.2024,54.8702,48.2967,35.0921,18.681,33.1653,37.9474,22},
{32.7207,39.6409,52.6833,53.0111,42.1056,27.9933,25.6728,37.9893,31.5163,10}
};




double mczhang[2][10]=
{
{15.1141,38.8958,46.2024,54.8702,48.2967,40.1876,53.5428,52.3339,37.9474,22},
{32.7207,39.6409,52.6833,53.0111,42.1056,47.0624,54.579,42.743,31.5163,10}
};






    TString fileribbon= Form(zhangname);

 
    TFile fin(fileribbon + "-truncated.root","READ");
    TFile fout(fileribbon + "-scaled.root","recreate");


    TTree * truncatedtree = (TTree *)fin.Get("truncatedtree"); 
    TTree * scaledtree = new TTree ("scaledtree", "scaledtree");


   UInt_t  truncatedtrig;
   double  truncatedsinglecal[2][10][50];


   UInt_t  scaledtrig;
   double  scaledcal[2][10][50];


  truncatedtree->SetBranchAddress("truncatedtrig", &truncatedtrig);
  truncatedtree->SetBranchAddress("truncatedsinglecal", &truncatedsinglecal);

  scaledtree->Branch("scaledtrig",&scaledtrig,"scaledtrig/i");
  scaledtree->Branch("scaledcal",&scaledcal,"scaledcal[2][10][50]/D");


  int encal = truncatedtree->GetEntries();

  for (long i=0; i< encal; ++i)
 {


    truncatedtree->GetEntry(i);
    scaledtrig=truncatedtrig;


   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
//     scaledcal[l][m][n] = mchan[l][m]/datahan[l][m][n]*truncatedsinglecal[l][m][n] ;
//     scaledcal[l][m][n] =  mcmix[l][m]/datamix[l][m][n]*truncatedsinglecal[l][m][n] ;
     scaledcal[l][m][n] = mczhang[l][m]/datazhang[l][m][n]*truncatedsinglecal[l][m][n] ;

   }
   }
   }



  scaledtree->Fill();


}



  fout->Write();
  fout.Close();
  fin.Close();



}

}

EOA





#------------------------------------------------
# create subtract_five code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_five_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    

    TString fileribbon= Form(zhangname);

    TFile fin(fileribbon + "-scaled.root","READ");
    TFile fout(fileribbon + "-five.root","recreate");


    TTree * scaledtree = (TTree *)fin.Get("scaledtree"); 
    TTree * fivetree = new TTree ("fivetree", "fivetree");


   UInt_t  scaledtrig;
   double  scaledcal[2][10][50];

   UInt_t  fivetrig;
   double  fivesumcal[2][10][50];
   double  fivesinglecal[2][10][50];

   scaledtree->SetBranchAddress("scaledtrig", &scaledtrig);
   scaledtree->SetBranchAddress("scaledcal", &scaledcal);

   fivetree->Branch("fivetrig",&fivetrig,"fivetrig/i");
   fivetree->Branch("fivesumcal",&fivesumcal,"fivesumcal[2][10][50]/D");
   fivetree->Branch("fivesinglecal",&fivesinglecal,"fivesinglecal[2][10][50]/D");


  int encal = scaledtree->GetEntries();

  for (long i=0; i< encal; ++i)
 {

     scaledtree->GetEntry(i);
     fivetrig=scaledtrig;



    for(int l=0;l <2; l++)
   {

    for(int m=0;m <10; m++)
   {

   for(int n=0;n <1; n++)
   {
     int num1 = l*50*10 + m*50 + n;
     int num2 = l*50*10 + m*50 + n+1;
     int num3 = l*50*10 + m*50 + n+2;
     fivesumcal[l][m][n] =  scaledcal[l][m][n] +  scaledcal[l][m][n+1] +  scaledcal[l][m][n+2];
   }



   for(int n=1;n <2; n++)
    {
     fivesumcal[l][m][n] =  scaledcal[l][m][n-1]  +  scaledcal[l][m][n] + scaledcal[l][m][n+1] + scaledcal[l][m][n+2];
    }

   for(int n=48;n <49; n++)
    {
     fivesumcal[l][m][n] =  scaledcal[l][m][n-2] +  scaledcal[l][m][n-1] +  scaledcal[l][m][n] + scaledcal[l][m][n+1];
    }


   for(int n=49;n <50; n++)
    {
      fivesumcal[l][m][n] = scaledcal[l][m][n-2]  +  scaledcal[l][m][n-1]  +  scaledcal[l][m][n];
    }


    for(int n=2;n <48; n++)
     {
      fivesumcal[l][m][n] = scaledcal[l][m][n-2] + scaledcal[l][m][n-1] + scaledcal[l][m][n] + scaledcal[l][m][n+1] + scaledcal[l][m][n+2];
     }



     for(n=0;n<50; n++)
    {
     fivesinglecal[l][m][n] =  scaledcal[l][m][n];
    }



    }
   }


   fivetree->Fill();

}



  fout->Write();
  fout.Close();
  fin.Close();



}

}

EOA





#------------------------------------------------
# create subtract_final code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_final_$ijob.C <<-EOA

{ 
#include <TH1D.h>
#include <TTree.h>
#include <TFile.h>
#include <TCanvas.h>
#include<fstream>
#include <stdio.h>


    char zhangname[1000];

    ifstream fingeo("/${MCDirectory}/${AnaDirectory}_$ijob");  
 
    while( fingeo >> zhangname ) 
    {    

    TString fileribbon= Form(zhangname);

    TFile fin(fileribbon + "-five.root","READ");
    TFile fout(fileribbon + "-final.root","recreate");


    TTree * fivetree = (TTree *)fin.Get("fivetree"); 
    TTree * finaltree = new TTree ("finaltree", "finaltree");


   UInt_t  fivetrig;
   double  fivesinglecal[2][10][50];
   double  fivesumcal[2][10][50];

   UInt_t  finaltrig;
   double  finalsinglecal[2][10][50];
   double  finalsumcal[2][10][50];
   double  finalall[50];
   double  finalall1;

  fivetree->SetBranchAddress("fivetrig", &fivetrig);
  fivetree->SetBranchAddress("fivesinglecal", &fivesinglecal);
  fivetree->SetBranchAddress("fivesumcal", &fivesumcal);


  finaltree->Branch("finaltrig",&finaltrig,"finaltrig/i");
  finaltree->Branch("finalsinglecal",&finalsinglecal,"finalsinglecal[2][10][50]/D");
  finaltree->Branch("finalsumcal",&finalsumcal,"finalsumcal[2][10][50]/D");
  finaltree->Branch("finalall",&finalall,"finalall[50]/D");


  int encal = fivetree->GetEntries();

  for (long i=0; i< encal; ++i)
 {



    fivetree->GetEntry(i);



   for(int n=0; n <50; n++)
   {

    finaltrig=fivetrig;
    finalall1=0;


   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
 
    finalsinglecal[l][m][n] = fivesinglecal[l][m][n] ;
    finalsumcal[l][m][n] = fivesumcal[l][m][n] ;
    finalall1  = finalall1 + fivesumcal[l][m][n];
   }
   }

    finalall[n]= finalall1;
   }


   finaltree->Fill();


}



  fout->Write();
  fout.Close();
  fin.Close();

}

}

EOA




  let "ijob += 1"
  done




