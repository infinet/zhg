  user=zhanghg
  filenumber=6
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_angle
  even=36
  odd=36
  cut=2000


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
    int oddposition=$ijob;
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



   if(sumcal[0][0][oddposition] + sumcal[0][1][oddposition] +sumcal[0][2][oddposition] +sumcal[0][3][oddposition] +sumcal[0][4][oddposition] +sumcal[0][5][oddposition] +sumcal[0][6][oddposition] +sumcal[0][7][oddposition] +sumcal[0][8][oddposition] +sumcal[0][9][oddposition] +sumcal[1][0][evenposition] +sumcal[1][1][evenposition] +sumcal[1][2][evenposition] +sumcal[1][3][evenposition] +sumcal[1][4][evenposition] +sumcal[1][5][evenposition] +sumcal[1][6][evenposition] +sumcal[1][7][evenposition] +sumcal[1][8][evenposition] +sumcal[1][9][evenposition]  > energycut)
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




double factor1[2][10][50]=
{
{

{0.0352046,  0.0172471,  0.024143,   0.0272212,  0.0195228,  0.0184256,  0.0175939,  0.0148014,  0.0188359,  0.0178152,  0.0177857,  0.0163461,  0.0224792,  0.0189397,  0.0156844,  0.0167243,  0.0191692,  0.0194714,  0.0184597,  0.0186187,  0.0205708,  0.0173347,  0.0190836,  0.0252488,  0.017372,   0.0171156,  0.0186306,  0.0326191,  0.0189056,  0.0263949,  0.0185857,  0.0199376,  0.0169156,  0.0194715,  0.0219574,  0.0236396,  0.0176743,  0.024325,   0.0169561,  0.0413265,  0.0200829,  0.0200554,  0.0180561,  0.0189182,  0.0188777,  0.0234806,  0.0169332,  0.00283547, 0.0161844,  0.0213283},

{0.0535404,  0.0789026,  0.0814776,  0.0322104,  0.0431953,  0.0415138,  0.0366367,  0.0376825,  0.0634294,  0.0358665,  0.0388341,  0.0347549,  0.0404609,  0.0364432,  0.0385059,  0.0359862,  0.0767527,  0.0385379,  0.033875,   0.0385565,  0.0418467,  0.0352186,  0.0505296,  0.0546988,  0.0702902,  0.0355528,  0.0387615,  0.0874193,  0.0378256,  0.0826345,  0.0389668,  0.0363232,  0.0362807,  0.0634954,  0.0708146,  0.0380571,  0.0354501,  0.0433621,  0.0374778,  0.0418479,  0.0341363,  0.0374637,  0.0369265,  0.0404863,  0.0328701,  0.0962626,  0.0415795,  0.107745,   0.0365575,  0.0506284},

{0.0817563,  0.113932,   0.0660478,  0.31062,    0.0632845,  0.130948,   0.110587,   0.128943,   0.0599944,  0.173918,   0.0633461,  0.120106,   0.0670125,  0.132163,   0.058167,   0.154917,   0.0599056,  0.117293,   0.0588994,  0.112473,   0.0595832,  0.185102,   0.0585593,  0.150889,   0.0586323,  0.130826,   0.058311,   0.132806,   0.0566946,  0.13487,    0.0569479,  0.148576,   0.0561177,  0.179497,   0.0598758,  0.139669,   0.0721521,  0.143233,   0.0616687,  0.133272,   0.058365,   0.121137,   0.0557936,  0.129209,   0.0560032,  0.156398,   0.0608673,  0.182127,   0.0754865,  0.154407},

{0.0796378,  0.13205,    0.135781,   0.0974081,  0.130533,   0.0728092,  0.0863986,  0.084916,   0.0932975,  0.078531,   0.0855907,  0.0780951,  0.0856451,  0.0746318,  0.0727516,  0.0738862,  0.0848045,  0.0748149,  0.0829967,  0.0747698,  0.0788115,  0.0834966,  0.0783133,  0.0795936,  0.0765838,  0.0798869,  0.0805137,  0.0903795,  0.119855,   0.0750594,  0.0746044,  0.0822947,  0.0868591,  0.0845447,  0.0828049,  0.074144,   0.0913877,  0.107009,   0.0727637,  0.0819152,  0.0795036,  0.0823406,  0.0991219,  0.0685468,  0.10173,    0.0875556,  0.125544,   0.128529,   0.0810049,  0.0818741},

{0.105652,   0.133444,   0.29572,    0.126224,   0.357652,   0.0780502,  0.0778725,  0.117812,   0.0786485,  0.0830942,  0.0763301,  0.0793944,  0.105223,   0.100098,   0.0804672,  0.0976276,  0.070149,   0.0872127,  0.0869286,  0.0939434,  0.0938326,  0.0991131,  0.0804514,  0.117772,   0.0937231,  0.114907,   0.0949536,  0.106458,   0.0701715,  0.0897365,  0.0831264,  0.0902722,  0.078441,   0.114095,   0.0860606,  0.095042,   0.0814403,  0.0831155,  0.0847819,  0.0859548,  0.0670033,  0.0818498,  0.0896957,  0.0938727,  0.0954579,  0.116721,   0.203025,   0.138164,   0.0749108,  0.466295},

{0.172494,   0.0838888,  0.111774,   0.108998,   0.0840704,  0.0762392,  0.0694119,  0.138792,   0.0795188,  0.0743683,  0.0870118,  0.0831561,  0.0858968,  0.0838292,  0.0611205,  0.077478,   0.0705048,  0.0774237,  0.0873359,  0.0753784,  0.0674663,  0.069267,   0.0753911,  0.151937,   0.0710786,  0.0839916,  0.083758,   0.14886,    0.062816,   0.0765162,  0.0674154,  0.132551,   0.0764929,  0.0886379,  0.0793703,  0.0815876,  0.0742726,  0.0831575,  0.0606188,  0.104081,   0.0655268,  0.0736547,  0.0673503,  0.0782871,  0.067993,   0.0835594,  0.125821,   0.127335,   0.128482,   0.0948355},

{0.0743576,  0.0378933,  0.131709,   0.0609669,  0.0655744,  0.02969,    0.0566783,  0.0284427,  0.0531889,  0.0286573,  0.0504835,  0.0303054,  0.0503346,  0.0269372,  0.0486844,  0.0319154,  0.0441062,  0.0310211,  0.0545261,  0.0290542,  0.0527156,  0.0312691,  0.124266,   0.031398,   0.0519631,  0.0297466,  0.0515802,  0.0323574,  0.0466668,  0.0330928,  0.0546385,  0.0336202,  0.0541455,  0.0313488,  0.0518242,  0.0340801,  0.0504796,  0.0278529,  0.0874214,  0.0325493,  0.128066,   0.0324663,  0.0533859,  0.0347377,  0.127362,   0.112879,   0.048692,   0.078314,   0.0636992,  0.0543366},

{0.0278049,  0.0209039,  0.0459707,  0.0222196,  0.0288736,  0.016421,   0.0251348,  0.0188861,  0.0246693,  0.015629,   0.0227048,  0.0191286,  0.0254932,  0.016387,   0.0231447,  0.0159428,  0.023539,   0.0201241,  0.0284853,  0.0243031,  0.0282074,  0.0167536,  0.0311767,  0.0152428,  0.0233258,  0.0173299,  0.0272243,  0.0182885,  0.022461,   0.0166694,  0.0235605,  0.0198805,  0.0218874,  0.0182133,  0.0267174,  0.017974,   0.0243841,  0.0173902,  0.0274314,  0.0203369,  0.0284848,  0.0172677,  0.0220209,  0.0182339,  0.0244204,  0.0255517,  0.0290469,  0.0292501,  0.0361885,  0.021598},

{0.0410372,  0.0140251,  0.00232758, 0.0376067,  0.0154189,  0.0116314,  0.0138047,  0.0104284,  0.0135201,  0.011905,   0.0126403,  0.0179254,  0.0125996,  0.0105286,  0.0113232,  0.0121311,  0.0294776,  0.0120504,  0.0115052,  0.0132067,  0.0138245,  0.0169571,  0.0116994,  0.0156407,  0.0109507,  0.0153401,  0.0123425,  0.018032,   0.011952,   0.0151412,  0.0121869,  0.0128028,  0.0204269,  0.0126631,  0.012672,   0.0127135,  0.0128826,  0.0152018,  0.0135443,  0.0143468,  0.0197487,  0.0123312,  0.0219457,  0.0145353,  0.0169363,  0.0153415,  0.0144153,  0.0153415,  0.0144153,  0.05055},

{0.0934999,  0.0131954,  0.0103302,  0.00196911, 0.0044906,  0.00963003, 0.0138206,  0.010327,   0.0146708,  0.0105019,  0.011016,   0.00331952, 0.0102571,  0.0104042,  0.0123479,  0.00909553, 0.0149377,  0.0111748,  0.0124229,  0.0105019,  0.0210562,  0.0114811,  0.012131,   0.0122752,  0.0185692,  0.0153766,  0.0278749,  0.00930542, 0.00967372, 0.0128801,  0.0117789,  0.0023699,  0.0657806,  0.0164574,  0.0107321,  0.011533,   0.0111525,  0.0143142,  0.0117285,  0.0105811,  0.0847583,  0.00952383, 0.02865,    0.011111,   0.014266,   0.000798398,    0.0162734,  0.000777888,    0.0162734,  0.000822234}

},
{

{0.0901417,  0.025366,   4.94081,    0.0326234,  0.0468974,  0.0241782,  0.047221,   0.0229241,  0.0484495,  0.0227168,  0.0487197,  0.0243683,  0.0495241,  0.0241571,  0.0397084,  0.0235189,  0.0446339,  0.0260832,  0.0344688,  0.0207603,  0.0363696,  0.0220454,  0.0588547,  0.0225078,  0.0346065,  0.0249089,  0.108631,   0.0225164,  0.140133,   0.0269217,  0.051412,   0.0244774,  0.0468836,  0.0225305,  0.038771,   0.0213666,  0.0550461,  0.0221782,  0.035828,   0.0332774,  0.0358615,  0.0224652,  0.0369983,  0.0225363,  0.0405032,  0.022886,   0.0485678,  0.0231807,  0.11036,    0.0602269},

{0.0892482,  1.76003,    0.168243,   2.7551, 0.0757921,  0.0518183,  0.0758661,  0.0557424,  0.0702401,  0.0569395,  0.0612385,  0.0629036,  0.0715453,  0.0488989,  0.063649,   0.05894,    0.0681687,  0.053858,   0.0638904,  0.0471778,  0.0590249,  0.0568749,  0.0545978,  0.0571535,  0.0557621,  0.0587006,  0.0942395,  0.0564094,  0.0640509,  0.0597981,  0.0666555,  0.0510117,  0.0915338,  0.058989,   0.0582044,  0.0628378,  0.0578133,  0.0672583,  0.0569826,  0.0645675,  0.432109,   1.38404,    0.0553564,  1.78124,    0.0944804,  0.080171,   0.113922,   0.0815818,  0.108515,   0.6370},

{0.177775,   0.0960468,  0.0887807,  0.227259,   0.0948525,  0.0825634,  0.0837485,  0.0891404,  0.101319,   0.0780804,  0.0994338,  0.0832776,  0.0897862,  0.0808556,  0.0903024,  0.0748805,  0.0895132,  0.0821474,  0.0906226,  0.0882824,  0.0967995,  0.090322,   0.0858024,  0.0755091,  0.0903254,  0.0924046,  0.0890355,  0.108181,   0.0867356,  0.0917666,  0.087123,   0.0914455,  0.0878033,  0.0844724,  0.0798237,  0.102893,   0.0961299,  0.0781362,  0.0898726,  0.110953,   0.0893593,  0.0859202,  0.097948,   0.0850406,  0.104128,   0.101247,   0.0979788,  0.083098,   0.0923374,  0.094066},

{0.118127,   0.128154,   0.141848,   0.103679,   0.110731,   0.0864398,  0.0887225,  0.0796692,  0.114791,   0.0845325,  0.0863049,  0.0766413,  0.102181,   0.0703708,  0.105736,   0.0994335,  0.0892206,  0.0818553,  0.083066,   0.0815046,  0.108885,   0.0849785,  0.0935204,  0.0924723,  0.0858331,  0.125859,   0.0848857,  0.0887725,  0.0899095,  0.0911151,  0.0998647,  0.0789588,  0.0913875,  0.0936744,  0.0798129,  0.0901638,  0.0961795,  0.0780064,  0.0824914,  0.0855496,  0.0868984,  0.0861128,  0.087031,   0.0885749,  0.0900212,  0.0745145,  0.0988072,  0.0811131,  0.112661,   0.150416},

{0.131174,   2.42637,    0.137749,   0.130225,   0.12466,    0.0642768,  0.0745606,  0.0640249,  0.0752127,  0.0667323,  0.0745937,  0.0671969,  0.0737039,  0.078506,   0.0782463,  0.0637291,  0.0652129,  0.0700026,  0.0729991,  0.0860612,  0.0795949,  0.0643192,  0.0739335,  0.0620431,  0.0731388,  0.0712743,  0.0750539,  0.0636674,  0.0760279,  0.0788533,  0.0657615,  0.0669538,  0.0821092,  0.079824,   0.079848,   0.0739476,  0.0658476,  0.0728545,  0.0760886,  0.0765475,  0.0704332,  0.0710515,  0.0678312,  0.0685542,  0.0793669,  3.308,  0.102431,   2.37674,    0.0785199,  0.29309},

{0.108445,   0.176442,   0.0718954,  0.261148,   0.0758833,  0.0405235,  0.0546093,  0.044967,   0.0500198,  0.0424177,  0.0486026,  0.0402332,  0.0553163,  0.0625174,  0.0562539,  0.0412483,  0.0551763,  0.0452999,  0.05662,    0.0433015,  0.0633702,  0.0469513,  0.0684905,  0.0467796,  0.0582717,  0.0432731,  0.0543209,  0.0363937,  0.0552505,  0.0433939,  0.0503989,  0.0390069,  0.052109,   0.0388717,  0.0500263,  0.042884,   0.083686,   0.0392499,  0.0715431,  0.0463568,  0.0529392,  0.0398565,  0.0603742,  0.053619,   0.0556896,  0.093982,   0.0548982,  0.0404369,  0.0830064,  0.071434},

{0.0215111,  0.0438137,  0.0527929,  0.0294659,  0.0474631,  0.028363,   0.0350112,  0.0225097,  0.0271933,  0.021287,   0.0565948,  0.0261265,  0.0325775,  0.0232021,  0.0280181,  0.0227239,  0.026667,   0.0251259,  0.0238311,  0.0298293,  0.0267128,  0.0397002,  0.0311749,  0.0223871,  0.0437909,  0.0233377,  0.0278936,  0.0244787,  0.0265018,  0.0209911,  0.0274418,  0.0219482,  0.0262508,  0.026288,   0.0290181,  0.0270089,  0.0269185,  0.0233587,  0.0548932,  0.0207672,  0.0683752,  0.0214067,  0.024511,   0.023257,   0.0306241,  0.0237428,  0.0388312,  0.0472046,  0.0402847,  0.061000},

{0.0195473,  0.0203871,  0.0228441,  0.020679,   0.0207201,  0.0183538,  0.0151894,  0.018727,   0.0198391,  0.0189498,  0.0202247,  0.015161,   0.0738067,  0.0167672,  0.0186706,  0.0159856,  0.0194594,  0.0172574,  0.0173084,  0.0309022,  0.0165805,  0.0153526,  0.0150617,  0.0172358,  0.0156006,  0.013872,   0.0302073,  0.0162469,  0.0171931,  0.017008,   0.01624,    0.0248336,  0.0152078,  0.0176113,  0.0187518,  0.0176098,  0.0189213,  0.0182614,  0.0170182,  0.020073,   0.0171905,  0.0193996,  0.0217106,  0.0199483,  0.0153063,  0.0207138,  0.0256281,  0.0190004,  0.0207142,  0.0280783},

{0.0114078,  0.0178674,  0.00878435, 0.0127153,  0.0114078,  0.0178674,  0.00878435, 0.0127153,  0.00986351, 0.0103695,  0.0115199,  0.0100991,  0.00989367, 0.0104556,  0.00927694, 0.00864705, 0.00957726, 0.00847203, 0.00934288, 0.00953637, 0.0110811,  0.0160186,  0.0106768,  0.00808138, 0.00808138, 0.00934918, 0.00992743, 0.00933529, 0.00934918, 0.00992743, 0.00934918, 0.00992743, 0.00933529, 0.0103603,  0.00856729, 0.0102552,  0.00942514, 0.00930474, 0.0108902,  0.00973628, 0.00898233, 0.00930131, 0.00869672, 0.0118084,  0.0146568,  0.0124841,  0.0122629,  0.0160244,  0.00852092, 0.0140213},

{0.0359614,  0.0183717,  0.0214887,  0.0151554,  0.0359614,  0.0183717,  0.0214887,  0.0151554,  0.0181499,  0.0166762,  0.0221853,  0.0168984,  0.0198106,  0.0156171,  0.0182675,  0.0186777,  0.0238079,  0.0206619,  0.0193739,  0.015792,   0.0202273,  0.0155189,  0.0184917,  0.0183927,  0.0183927,  0.0342198,  0.0190796,  0.0212554,  0.0342198,  0.0190796,  0.0342198,  0.0190796,  0.0212554,  0.0179224,  0.0213106,  0.0179476,  0.0221098,  0.0195173,  0.0203822,  0.0162333,  0.0192852,  0.0192634,  0.0185391,  0.0201015,  0.0253282,  0.0208608,  0.0211459,  0.0261901,  0.0194044,  0.0516221}

}
};





double factor2[2][10][50]=
{
{

{0.610726187,    0.829438985,    0.904817171,    0.981789292,    1.027754395,    0.984439209,    0.84677801, 0.927959116,    0.902939316,    0.918729235,    0.872619682,    0.936800474,    0.803806516,    0.86980539, 0.939420505,    0.932347418,    0.956894018,    0.915317218,    0.879787409,    0.916677044,    0.986845055,    0.953103441,    1,  0.886367372,    0.914410667,    0.968704081,    1.053551238,    1.034130135,    1.035758937,    0.971040192,    1.057685507,    1.088453435,    1.03976868, 0.975099745,    0.940511354,    1.109911786,    1.068125781,    1.038637982,    1.038637982,    1.070297518,    1.052540085,    0.987462704,    1.056764013,    1.082789984,    1.067129572,    1.140515339,    1.078386738,    1.121931052,    1.190315848,    1.053536294},

{0.9900598,  0.983239702,    1.002200761,    0.9633395,  1.014353038,    0.98077021, 0.949116584,    0.944406728,    0.964564345,    0.98196111, 0.963551656,    1.003589674,    0.946338759,    1.007470708,    0.993771109,    0.977805688,    1.017345848,    1.031328321,    1.016839503,    0.971011049,    0.96282184, 1.01428232, 1,  0.991083804,    0.946706495,    1.027591552,    1.044465,   1.004845636,    1.030290172,    1.00883982, 1.020910063,    1.009521547,    0.973670067,    0.986379606,    0.908071533,    0.985519668,    1.043127005,    0.982662639,    0.982662639,    1.025141861,    1.067242033,    1.036804766,    1.095438936,    1.075202114,    1.055587615,    1.143536041,    0.982314703,    1.037690162,    1.106768049,    1.01551848},

{0.822458008,    0.933647595,    0.971716485,    0.950923661,    0.948438487,    0.95779599, 0.940610773,    1.004308027,    0.98205868, 0.989854157,    0.977113241,    0.998051131,    0.980483466,    0.977445868,    0.986415062,    0.948680264,    1.020477781,    1.039734954,    1.01801312, 1.013310924,    1.016890689,    1.006173373,    1,  1.022548271,    1.005174028,    0.997171942,    0.968026821,    1.028180943,    1.010645515,    1.046029948,    1.020934959,    1.055742058,    1.028141379,    1.028084232,    0.990771445,    1.013807666,    0.997673079,    1.073686308,    0.991130447,    0.973008893,    1.096222857,    1.03532582, 1.022453026,    1.014173994,    1.058082166,    1.071552809,    1.110766111,    0.963660182,    1.21843308, 1.025720679},

{0.761306749,    0.917721175,    0.975958482,    0.985655914,    0.996822897,    1.000445657,    1.004407053,    1.02480185, 1.004421429,    1.004137103,    0.981296782,    0.995795809,    0.982566665,    1.022974497,    1.012957597,    0.953975931,    1.030200849,    0.994735178,    0.978862441,    1.011738829,    1.012232406,    0.968161881,    1,  0.982440475,    0.998279668,    0.998354743,    1.026403979,    1.045929826,    1.052049224,    1.072092607,    1.057064861,    1.123236141,    1.092661515,    1.063259334,    1.073217132,    1.068912309,    1.036986336,    1.098725006,    1.057644695,    1.066289482,    1.115046594,    1.114404465,    1.101876551,    1.125721597,    1.110954217,    1.159184208,    1.216974261,    1.196860594,    1.252436737,    1.180179605},

{0.87044545, 0.941497738,    0.954427505,    0.924247501,    0.932464027,    0.963262039,    0.956724558,    0.990428324,    0.968714283,    0.994173601,    0.951335604,    1.002029002,    0.949991623,    0.998172037,    0.982249027,    0.981022319,    1.001440777,    1.035163158,    1.02154837, 1.010878427,    1.001236016,    1.013380242,    1,  0.993644943,    1.01891253, 1.035433071,    1.012051153,    1.019785559,    1.027160701,    1.018979542,    1.005681205,    1.051970365,    1.077036913,    1.029124551,    1.044364401,    1.077306826,    1.047020718,    1.065955585,    1.051430539,    1.09323542, 1.084501405,    1.112397386,    1.11559353, 1.110014706,    1.118210756,    1.137573761,    1.131265241,    1.166644329,    1.237048826,    1.225824166},

{0.83859585, 0.987389911,    1.02104106, 1.042888434,    1.031932536,    1.030188985,    1.016090956,    1.009603036,    1.017784631,    1.02509549, 1.058493107,    1.039127019,    1.03781572, 1.021415123,    1.031444175,    1.071583244,    1.071921979,    1.07859693, 1.089315921,    1.02956139, 0.995116396,    1.022061421,    1,  1.011250992,    1.00022236, 0.985652595,    1.01623019, 1.047543443,    1.066878359,    1.088829639,    1.085708289,    1.088480513,    1.107462147,    1.097175407,    1.127183594,    1.123079289,    1.16271545, 1.133472014,    1.106844942,    1.123571806,    1.08395227, 1.151915412,    1.137794523,    1.164080781,    1.203450942,    1.241139896,    1.21823891, 1.235244243,    1.251306104,    1.236904668},

{0.89080791, 0.938492334,    0.965703895,    0.94934447, 0.945859839,    0.995954684,    0.952472778,    0.975335101,    0.950712122,    0.937344764,    0.94589652, 0.91438812, 0.915986334,    0.957078779,    0.930726585,    0.983299972,    0.966982467,    0.976487911,    1.017894759,    0.984143619,    0.992003689,    1.010873097,    1,  1.009840807,    0.985443151,    0.98645972, 0.984599503,    1.004207757,    1.0225584,  1.069341536,    1.068974732,    1.06193735, 1.057588111,    1.058085916,    1.043602427,    1.100708454,    1.064494493,    1.045258282,    1.094441359,    1.127867615,    1.119095778,    1.116187552,    1.093073706,    1.074047098,    1.157783041,    1.150651338,    1.131436087,    1.156588311,    1.178020101,    1.023302487},

{0.858806287,    0.951105458,    0.989159872,    1.010391622,    0.966906115,    1.00771774, 0.983922396,    0.994448815,    0.982165134,    0.997536891,    0.988363344,    0.973430289,    0.947747787,    0.974900802,    1.006752103,    0.998353026,    0.988027577,    1.003654224,    0.982145527,    1.024224243,    1.040372922,    0.995791883,    1,  1.060942942,    1.095249999,    1.043301693,    1.029231339,    1.055080498,    1.082213906,    1.071653175,    1.092407008,    1.072229125,    1.075390727,    1.093718215,    1.0856402,  1.117018487,    1.140198666,    1.113984329,    1.104580401,    1.146186103,    1.108489514,    1.137027261,    1.139982991,    1.182306793,    1.210219572,    1.224792351,    1.239862654,    1.305261249,    1.35194512, 1.316706738},

{0.779493416,    0.955949587,    0.907784471,    0.914753071,    0.951146744,    0.960568611,    0.971437459,    0.937398075,    0.986263115,    0.921488363,    0.939985672,    0.922805728,    0.982970881,    0.976518387,    1.021150891,    1.018631637,    1.011992968,    1.034454154,    1.027021295,    1.031755795,    1.034571986,    0.963167991,    1,  0.995352696,    1.196226068,    1.195207998,    1.158288793,    1.131719974,    1.108393899,    1.113562022,    1.103572203,    1.101265047,    1.093867538,    1.081257129,    1.061623917,    1.111825175,    1.100525061,    1.082053675,    1.098373443,    1.056743305,    1.07310078, 1.080250841,    1.107347549,    1.055621542,    1.067063054,    1.092458264,    1.085708832,    1.00885156, 1.01721765, 0.98422226},

{0.89313986, 0.893893097,    0.917723093,    0.985294118,    0.913168142,    0.912194619,    0.882793514,    1.003545898,    0.945450734,    0.984050566,    0.997448943,    0.982089308,    0.995931811,    0.999211233,    0.958046132,    0.937797564,    0.945358356,    1.013320211,    0.877993406,    1.067041627,    1.048885778,    1.036908603,    1,  1.139832014,    1.164575132,    1.08346361, 1.055949149,    1.040010375,    1.021836761,    1.002568822,    1.083445845,    0.984295724,    1.030467007,    1.009792078,    1.052204284,    1.031575544,    1.000540057,    0.934908972,    1.05105311, 0.998376277,    1.005091454,    0.932137629,    0.96259753, 0.949454969,    1.026889132,    0.94639228, 0.882605204,    0.969085315,    1.058944332,    1.024430454}

},
{
{1.089834046,    1.117058435,    1.154938646,    1.158324257,    1.140580651,    1.122756563,    1.097753478,    1.138461291,    1.104889552,    1.069016027,    1.056407175,    1.07443515, 1.050934396,    1.046668849,    1.041201436,    1.055060442,    1.019986372,    0.999275662,    1.019508845,    1.011074328,    0.999908787,    0.978285947,    1,  1.009818808,    0.936531868,    0.964035262,    0.921132972,    0.984998149,    0.968590545,    0.967855476,    0.898533617,    0.987493092,    0.946146788,    0.88545797, 0.936322615,    0.908711912,    0.93455201, 0.942353402,    0.951115213,    0.917087409,    0.893752985,    0.889868385,    0.902965495,    0.904129801,    0.926203341,    0.918251716,    0.907279332,    0.915890909,    0.877280995,    0.786314835},

{1.135089927,    1.111026465,    1.107918596,    1.102353265,    1.082754192,    1.065438919,    1.068808918,    1.072899772,    1.061765833,    1.033298601,    1.029530494,    1.018835622,    0.97337914, 1.008951713,    0.957195938,    0.97095936, 0.998781099,    0.989316596,    0.966857038,    1.017638019,    0.993227237,    0.988202547,    1,  0.977730485,    0.965636499,    0.936436943,    0.94946968, 0.962821886,    0.972519029,    0.968292195,    0.920437232,    0.945773658,    0.946166852,    0.921860921,    0.896467154,    0.889653432,    0.891793062,    0.910846579,    0.899011445,    0.886591436,    0.859706808,    0.904802862,    0.874830026,    0.853844944,    0.872908291,    0.872624864,    0.847268777,    0.831847388,    0.831123256,    0.711407208},

{1.283041246,    1.287869169,    1.255761763,    1.19260506, 1.172784824,    1.12563753, 1.116742867,    1.084246669,    1.098006985,    1.100528397,    1.08996865, 1.048833703,    1.025711188,    1.019920306,    1.040393452,    1.0141163,  1.04179934, 1.014334483,    1.029910807,    1.011112588,    1.038396992,    1.04166154, 1,  0.97737783, 1.002385253,    1.018440596,    1.020035139,    0.987506131,    1.010220168,    0.973166727,    0.979474359,    0.991021672,    0.996153083,    0.990880591,    0.987965465,    0.970220431,    0.970541964,    0.952570545,    0.972997757,    0.939984809,    0.973434124,    0.944642122,    0.947212748,    0.910080564,    0.959109484,    0.944975139,    0.941170874,    0.9394008,  0.872167512,    0.849989911},

{1.29759466, 1.267796683,    1.226962418,    1.179959242,    1.176437971,    1.137347404,    1.117230694,    1.134623099,    1.10634952, 1.104609389,    1.103297158,    1.051209089,    1.03478481, 1.064629143,    1.057376216,    1.051681563,    1.035202014,    1.028790626,    1.058294421,    1.044524914,    1.021375453,    1.028171952,    1,  0.974559485,    0.998122583,    1.008164,   0.995170064,    1.003273445,    0.997634062,    0.98924898, 0.997341663,    0.991789644,    0.988106127,    0.963164829,    0.946836829,    0.989011851,    0.998293744,    0.983707658,    0.967764768,    0.98184807, 0.962307244,    0.963988539,    0.973315005,    0.953167985,    0.965580689,    0.954524789,    0.946237767,    0.923136445,    0.830818522,    0.830096438},

{1.297001253,    1.262367964,    1.195468227,    1.157578194,    1.131771018,    1.129959431,    1.09017555, 1.076239975,    1.05886257, 1.023212249,    1.046394586,    1.039299669,    1.082805811,    1.050860925,    1.037661949,    1.05276412, 1.009878667,    1.012163249,    1.0352035,  1.050859055,    1.032440315,    1.036944045,    1,  0.999252183,    0.994798931,    0.974463908,    0.984007927,    0.985496083,    0.959675821,    0.96491989, 0.954250407,    0.984413618,    0.947090056,    0.94469891, 0.921595094,    0.918523435,    0.946226327,    0.92881714, 0.928577838,    0.91355045, 0.892521827,    0.906967788,    0.935917665,    0.926842902,    0.926620427,    0.901327376,    0.928577838,    0.87662697, 0.800515994,    0.41620894},

{1.355598046,    1.338180279,    1.287211772,    1.270844512,    1.225806208,    1.212290686,    1.171676101,    1.174752047,    1.148494399,    1.121619545,    1.118573829,    1.123073125,    1.100805893,    1.098163249,    1.107995697,    1.095057073,    1.077639306,    1.073243297,    1.063340312,    1.052679046,    1.054616313,    1.044562175,    1,  1.021224282,    1.027983303,    1.041705399,    1.01961955, 1.032535502,    1.032238236,    1.020135987,    1.003647805,    0.999924424,    0.989515079,    0.964154266,    0.945358495,    0.940435973,    0.952906026,    0.949233029,    0.955956781,    0.937289489,    0.932805308,    0.930391912,    0.944960461,    0.959607105,    0.934022083,    0.941269829,    0.930648871,    0.912820474,    0.89431945, 0.832991981},

{1.226731009,    1.209458012,    1.18640537, 1.161792947,    1.150353166,    1.137347422,    1.117484402,    1.108051528,    1.107394236,    1.084809323,    1.086274324,    1.071412088,    1.041681433,    1.043193825,    1.042847665,    1.023085609,    1.011268761,    1.04351526, 1.023060883,    1.013393115,    1.03431316, 1.034039116,    1,  0.983650098,    0.9711059,  0.961922345,    0.960251296,    0.959012948,    0.95175594, 0.952646067,    0.956635155,    0.952685216,    0.939512573,    0.954834296,    0.941144473,    0.929249326,    0.93089771, 0.934429371,    0.949592437,    0.919373449,    0.923356356,    0.920156432,    0.915608954,    0.95068037, 0.900625149,    0.905910278,    0.910651441,    0.896085914,    0.89254395, 0.825022047},

{1.244426113,    1.234983377,    1.183363681,    1.157830879,    1.160948763,    1.147577493,    1.107855644,    1.114545733,    1.102820706,    1.072347393,    1.068311959,    1.053629396,    1.029105007,    1.047897833,    1.067349869,    1.063784791,    1.038467569,    1.045513988,    1.018584374,    1.038467569,    1.016697608,    0.995259034,    1,  0.963827194,    0.979259832,    0.993733943,    0.988266064,    0.97944156, 0.970725737,    0.969011791,    0.971126607,    0.977996643,    0.971682482,    0.961126216,    0.958232819,    0.954067325,    0.95223579, 0.94723114, 0.946511354,    0.956313983,    0.920330033,    0.928516707,    0.916355175,    0.935017941,    0.889439814,    0.935516803,    0.894268081,    0.902629357,    0.91592758, 0.829751032},

{1.142183739,    1.167333409,    1.143517223,    1.096661247,    1.111485865,    1.065844897,    1.091917168,    1.061552035,    1.053777996,    1.05145133, 1.0349378,  1.028829987,    1.00366015, 0.987829748,    0.977963474,    1.020319885,    1.004260093,    0.993645152,    1.00784462, 1.014643123,    1.007804288,    0.971303614,    1,  0.975546061,    0.983857022,    0.958384694,    0.957386471,    0.952085303,    0.964079102,    0.946325355,    0.958810703,    0.955284153,    0.933439205,    0.938725249,    0.919146469,    0.926892779,    0.915166181,    0.897883818,    0.869605878,    0.914329288,    0.894379955,    0.875849813,    0.883250778,    0.888272142,    0.878526865,    0.870820887,    0.887248711,    0.847105532,    0.788475063,    0.699313092},

{1.00997117, 1.073617717,    1.136171658,    1.15211084, 1.141680592,    1.131250344,    1.112611785,    1.125355785,    1.13328865, 1.087463503,    1.109655324,    1.089217181,    1.012404282,    1.034568559,    1.023468057,    1.05770608, 1.043199221,    0.990800081,    0.984372992,    0.979010963,    0.967662559,    1.00100079, 1,  0.933048093,    0.980186202,    1.010072167,    1.020759498,    1.040408028,    0.971234185,    0.891877077,    0.910365977,    0.949657528,    0.940687148,    0.974603816,    0.946324623,    0.939052831,    0.92653837, 0.887927172,    0.890189507,    0.944754577,    0.915346053,    0.885213104,    0.885104762,    0.855772444,    0.87008649, 0.824905889,    0.801808767,    0.770186569,    0.645690178,    0.550893365}

}
};

double factoreven[50]={1.29759466,  1.267796683,    1.226962418,    1.179959242,    1.176437971,    1.137347404,    1.117230694,    1.134623099,    1.10634952, 1.104609389,    1.103297158,    1.051209089,    1.03478481, 1.064629143,    1.057376216,    1.051681563,    1.035202014,    1.028790626,    1.058294421,    1.044524914,    1.021375453,    1.028171952,    1,  0.974559485,    0.998122583,    1.008164,   0.995170064,    1.003273445,    0.997634062,    0.98924898, 0.997341663,    0.991789644,    0.988106127,    0.963164829,    0.946836829,    0.989011851,    0.998293744,    0.983707658,    0.967764768,    0.98184807, 0.962307244,    0.963988539,    0.973315005,    0.953167985,    0.965580689,    0.954524789,    0.946237767,    0.923136445,    0.830818522,    0.830096438};

double factorodd[50]={0.761306749,  0.917721175,    0.975958482,    0.985655914,    0.996822897,    1.000445657,    1.004407053,    1.02480185, 1.004421429,    1.004137103,    0.981296782,    0.995795809,    0.982566665,    1.022974497,    1.012957597,    0.953975931,    1.030200849,    0.994735178,    0.978862441,    1.011738829,    1.012232406,    0.968161881,    1,  0.982440475,    0.998279668,    0.998354743,    1.026403979,    1.045929826,    1.052049224,    1.072092607,    1.057064861,    1.123236141,    1.092661515,    1.063259334,    1.073217132,    1.068912309,    1.036986336,    1.098725006,    1.057644695,    1.066289482,    1.115046594,    1.114404465,    1.101876551,    1.125721597,    1.110954217,    1.159184208,    1.216974261,    1.196860594,    1.252436737,    1.180179605};



    int evenposition=$even;
    int oddposition=$odd;


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

  double comfactor =0.8;


  for (long i=0; i< encal; ++i)
 {
    truncatedtree->GetEntry(i);
    scaledtrig=truncatedtrig;




//without attenuation


/*
   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = factor1[l][m][n]*truncatedsinglecal[l][m][n] ;
   }
   }
   }

*/

//with attenuation, but following the exact value

/*

   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = factor1[l][m][n]*factor2[l][m][oddposition]*truncatedsinglecal[l][m][n] ;
   }
   }
   }



   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = factor1[l][m][n]*factor2[l][m][evenposition]*truncatedsinglecal[l][m][n] ;
   }
   }
   }

*/


// with attenuation, with layer 7 and 8

   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = comfactor*factor1[l][m][n]*factorodd[oddposition]*truncatedsinglecal[l][m][n] ;
   }
   }
   }



   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = comfactor*factor1[l][m][n]*factoreven[evenposition]*truncatedsinglecal[l][m][n] ;
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




