  user=zhanghg
  filenumber=8
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_hvscan
  even=36
  odd=36
  cut=20
  newodd=22
  neweven=22


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


//if(sumcal[0][0][oddposition] + sumcal[0][1][oddposition] +sumcal[0][2][oddposition] +sumcal[0][3][oddposition] +sumcal[0][4][oddposition] +sumcal[0][5][oddposition] +sumcal[0][6][oddposition] +sumcal[0][7][oddposition] +sumcal[0][8][oddposition] +sumcal[0][9][oddposition] +sumcal[1][0][evenposition] +sumcal[1][1][evenposition] +sumcal[1][2][evenposition] +sumcal[1][3][evenposition] +sumcal[1][4][evenposition] +sumcal[1][5][evenposition] +sumcal[1][6][evenposition] +sumcal[1][7][evenposition] +sumcal[1][8][evenposition] +sumcal[1][9][evenposition]  > energycut)

if(sumsinglecal[0][0][oddposition] > energycut && sumsinglecal[0][1][oddposition]>energycut&&sumsinglecal[0][0][evenposition] > energycut && sumsinglecal[1][1][evenposition]> energycut)
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







double factorzhang[2][10][50]=
{
{
{0.102124367,   0.04681868, 0.070094052,    0.094463125,    0.11148229, 0.058275273,    0.067520382,    0.051576566,    0.063357675,    0.058170531,    0.062924553,    0.066081813,    0.079495177,    0.057871179,    0.063014013,    0.075542549,    0.079983595,    0.067175569,    0.079328281,    0.074239023,    0.07924468, 0.063278362,    0.089242969,    0.079355354,    0.072124741,    0.056233071,    0.074483782,    0.088906471,    0.079547895,    0.042892211,    0.066938155,    0.048544073,    0.076077174,    0.057398877,    0.096998421,    0.094998083,    0.066138201,    0.069566238,    0.064445856,    0.079877072,    0.082578075,    0.059349881,    0.077717844,    0.064526747,    0.088193144,    0.07466039, 0.069564317,    0.045806133,    0.073197794,    0.104020675},
{0.091741219,   0.13519804, 0.139611128,    0.054045439,    0.071791947,    0.071717554,    0.061091408,    0.063906191,    0.108687257,    0.060724969,    0.064314284,    0.058364682,    0.069521093,    0.059723461,    0.065527146,    0.060074816,    0.131514918,    0.064233246,    0.057709159,    0.064524573,    0.069796671,    0.060216276,    0.090886744,    0.115155373,    0.120441688,    0.060153322,    0.068397359,    0.149789925,    0.064608602,    0.141594254,    0.06693524, 0.06137201, 0.061001441,    0.108798832,    0.121341578,    0.063481685,    0.059437892,    0.091714179,    0.063431889,    0.073452191,    0.057040078,    0.064588969,    0.061196754,    0.067977189,    0.057044177,    0.164945507,    0.074822926,    0.184610638,    0.064371122,    0.079372704},
{0.089780864,   0.113115862,    0.068137495,    0.312668507,    0.064260858,    0.130011003,    0.057805965,    0.128020305,    0.061341802,    0.172672776,    0.064911615,    0.119246156,    0.067138842,    0.131216559,    0.063624421,    0.15380805, 0.061817997,    0.116454816,    0.0607319,  0.111667972,    0.061307209,    0.183776775,    0.060403348,    0.149808858,    0.060091068,    0.129889291,    0.060188764,    0.131855412,    0.059245467,    0.133904475,    0.058245612,    0.147512061,    0.058491529,    0.178206686,    0.061457832,    0.138669324,    0.079848607,    0.142207612,    0.063291653,    0.13231913, 0.059436846,    0.12026989, 0.057352678,    0.128284054,    0.05729784, 0.155279741,    0.064422051,    0.180822818,    0.080080423,    0.153299246},
{0.085888616,   0.132912659,    0.138259106,    0.099567942,    0.130133335,    0.075928414,    0.087589673,    0.088708215,    0.0953843,  0.080659563,    0.087455093,    0.080002624,    0.088455667,    0.075756806,    0.074514948,    0.075331832,    0.086072252,    0.075367116,    0.083912476,    0.076054917,    0.0797982,  0.084973511,    0.079908136,    0.080403201,    0.078292608,    0.080748707,    0.082272926,    0.091866642,    0.1244527,  0.076682981,    0.075591595,    0.082556147,    0.087493861,    0.085362162,    0.083433488,    0.075956162,    0.094862375,    0.103519499,    0.074190325,    0.082165495,    0.081145288,    0.083516413,    0.100157894,    0.069692374,    0.111424922,    0.089358161,    0.132471759,    0.133048986,    0.082240988,    0.084547456},
{0.100512587,   0.136325838,    0.294804854,    0.127380503,    0.356538462,    0.077810179,    0.080023827,    0.113727332,    0.080041996,    0.082838271,    0.079542378,    0.079150135,    0.101458966,    0.099790281,    0.08379403, 0.097326463,    0.073659287,    0.086944319,    0.090425647,    0.09365434, 0.091326423,    0.098808084,    0.081789639,    0.116283723,    0.090941221,    0.116519098,    0.09149823, 0.106130732,    0.073422338,    0.089460367,    0.084080388,    0.089994466,    0.08011861, 0.10506363, 0.087596535,    0.094749573,    0.081871996,    0.082859731,    0.084083462,    0.085689877,    0.069797962,    0.081597977,    0.088685818,    0.093583928,    0.092658562,    0.118537544,    0.206244555,    0.169650209,    0.07901404, 0.431151244},
{0.196342601,   0.09774604, 0.129895115,    0.118168934,    0.09780813, 0.089063722,    0.081961148,    0.166781901,    0.090562585,    0.085509171,    0.103735367,    0.096925641,    0.098663216,    0.09705204, 0.072837667,    0.092958209,    0.086442792,    0.091144259,    0.099798355,    0.095803147,    0.079797466,    0.085763369,    0.086349367,    0.174246865,    0.086372009,    0.096921433,    0.096758086,    0.175038438,    0.077708704,    0.091821902,    0.081367394,    0.158119917,    0.091567078,    0.101487939,    0.091930075,    0.099747576,    0.086997257,    0.100457699,    0.072802568,    0.112053981,    0.076833778,    0.094746546,    0.080684059,    0.095630799,    0.080023576,    0.101452583,    0.149284181,    0.155141717,    0.152038014,    0.105386326},
{0.319935467,   0.154893469,    0.114573922,    0.148094428,    0.159286728,    0.070919682,    0.137677198,    0.067496398,    0.129201234,    0.068445947,    0.122629362,    0.071605503,    0.122267563,    0.064010119,    0.118259202,    0.077051308,    0.107138312,    0.074580455,    0.132449394,    0.068924821,    0.128051467,    0.074248883,    0.301851946,    0.074555946,    0.126223329,    0.070972984,    0.125293502,    0.075949927,    0.11335816, 0.07990759, 0.132722225,    0.080649257,    0.131524738,    0.075429074,    0.125886792,    0.085999958,    0.122620095,    0.066689668,    0.212355139,    0.081428839,    0.311085547,    0.078788423,    0.129679693,    0.088299523,    0.309376138,    0.274194589,    0.118277489,    0.190230332,    0.15473143, 0.131989025},
{0.176543672,   0.087780279,    0.282068709,    0.144750723,    0.15569032, 0.069215855,    0.134568695,    0.06535341, 0.126284102,    0.066503882,    0.119860612,    0.069234168,    0.119506982,    0.062387674,    0.115589123,    0.074349438,    0.104719322,    0.072527017,    0.129458925,    0.066934187,    0.125160295,    0.076503385,    0.268813211,    0.072047055,    0.123373433,    0.069197825,    0.122464601,    0.07465766, 0.110798737,    0.076638608,    0.129725596,    0.078276197,    0.128555146,    0.073613502,    0.123044495,    0.084058234,    0.119851554,    0.064848492,    0.207560542,    0.079464396,    0.26225827, 0.0768009,  0.126751759,    0.086305879,    0.283917256,    0.239080024,    0.115606996,    0.185935274,    0.151237873,    0.129008951},
{0.155792214,   0.079384711,    0.088221249,    0.191669024,    0.087275128,    0.065835755,    0.075748,   0.059026639,    0.076529536,    0.067384777,    0.071558363,    0.101460924,    0.071316294,    0.059593855,    0.064096332,    0.068664559,    0.227244908,    0.068207905,    0.065121491,    0.065121491,    0.078566696,    0.095978977,    0.066220628,    0.088528942,    0.061989045,    0.086830989,    0.070442416,    0.102062091,    0.067654725,    0.085702219,    0.06898875, 0.072465999,    0.129815475,    0.071675953,    0.073223179,    0.071960435,    0.064799118,    0.086044819,    0.076972414,    0.081205649,    0.111780959,    0.069796665,    0.166638416,    0.082272213,    0.095862111,    0.086835559,    0.081590643,    0.134768835,    0.275532224,    0.120556344},
{0.104761905,   0.088,  0.078571429,    0.122222222,    0.104761905,    0.062857143,    0.084615385,    0.073333333,    0.075862069,    0.06875,    0.073333333,    0.073333333,    0.064705882,    0.055,  0.066666667,    0.055,  0.091666667,    0.073333333,    0.11,   0.1,    0.06875,    0.06875,    0.066666667,    0.088,  0.091666667,    0.122222222,    0.11,   0.055,  0.061111111,    0.073333333,    0.078571429,    0.081481481,    0.1,    0.11,   0.057894737,    0.057894737,    0.064705882,    0.057894737,    0.073333333,    0.061111111,    0.088,  0.057894737,    0.057894737,    0.05,   0.084615385,    0.055,  0.073333333,    0.064705882,    0.115789474,    0.06875}
},
{
{0.164828173,   0.068451629,    0.152761982,    0.071696174,    0.126555611,    0.065246704,    0.13441468, 0.061862061,    0.130744211,    0.061302615,    0.13147285, 0.06575928, 0.133643883,    0.065189508,    0.107155559,    0.063467313,    0.12044725, 0.070387229,    0.093016255,    0.056022936,    0.098145415,    0.059490884,    0.153560635,    0.060738762,    0.093387923,    0.067218109,    0.240960138,    0.060761884,    0.273326205,    0.081682901,    0.154532445,    0.066053451,    0.126518421,    0.060800046,    0.104625887,    0.057659145,    0.15068109, 0.069685379,    0.09668409, 0.081729011,    0.096774451,    0.060624201,    0.099842245,    0.060815754,    0.109300352,    0.061759427,    0.131065768,    0.062554509,    0.254756733,    0.162521917},
{0.098843527,   0.220227222,    0.142487581,    0.1982045,  0.09246683, 0.056267335,    0.092112094,    0.061369702,    0.08835064, 0.061652895,    0.065489566,    0.068236143,    0.088900277,    0.05332077, 0.069381722,    0.064788168,    0.073070245,    0.058474908,    0.069727464,    0.05150055, 0.064975602,    0.062542638,    0.059292869,    0.062126353,    0.061358018,    0.065856438,    0.104371442,    0.0617223,  0.069078131,    0.064948242,    0.072474422,    0.055573251,    0.10137482, 0.063206694,    0.061952362,    0.070311463,    0.062550731,    0.096160928,    0.061997222,    0.069601486,    0.220227222,    0.132136333,    0.060423412,    0.09910225, 0.104638406,    0.089780559,    0.126170167,    0.09878515, 0.120180752,    0.264272667},
{0.126337334,   0.098439418,    0.089464014,    0.113945561,    0.097205247,    0.083689112,    0.085032999,    0.090751599,    0.10309218, 0.079686628,    0.10001215, 0.084692895,    0.090480868,    0.082123895,    0.090280077,    0.075833534,    0.091057466,    0.082937745,    0.090674907,    0.089540953,    0.096072893,    0.091438028,    0.086638052,    0.076838809,    0.091095883,    0.094837546,    0.089503531,    0.115626358,    0.086254924,    0.094532767,    0.087933443,    0.090264763,    0.085422082,    0.085642318,    0.081241586,    0.104037212,    0.098631083,    0.079325833,    0.090115151,    0.114499293,    0.088811288,    0.086646459,    0.09954689, 0.086219351,    0.108094916,    0.102242479,    0.09926816, 0.08575719, 0.092362674,    0.094783458},
{0.120297413,   0.131610752,    0.147205214,    0.093056458,    0.105893645,    0.085095648,    0.087863022,    0.079050136,    0.123108703,    0.084175468,    0.085906087,    0.075449041,    0.100658128,    0.069614051,    0.10699651, 0.097706408,    0.087854285,    0.081542115,    0.081744053,    0.080530081,    0.107332515,    0.083409803,    0.094571316,    0.089841556,    0.086058657,    0.130416952,    0.084252527,    0.087508254,    0.089864096,    0.091161272,    0.100539767,    0.078161409,    0.092825724,    0.094930858,    0.079204505,    0.090274069,    0.095409428,    0.077183059,    0.082275257,    0.084228431,    0.087099059,    0.084832691,    0.084634813,    0.08649846, 0.089495889,    0.073434069,    0.092033799,    0.08019045, 0.102660878,    0.15911413},
{0.131769831,   2.130796286,    0.138222453,    0.13159974, 0.125435241,    0.068820691,    0.07805862, 0.068178815,    0.080352972,    0.071647155,    0.079368305,    0.071798894,    0.078767573,    0.084888782,    0.082401176,    0.068802136,    0.069608229,    0.074475205,    0.076336481,    0.089904492,    0.083559105,    0.068757308,    0.078482452,    0.06631952, 0.078010027,    0.076119816,    0.077974344,    0.069094555,    0.082543168,    0.082446676,    0.071354176,    0.071440739,    0.08988741, 0.083498954,    0.083937731,    0.079797595,    0.070066929,    0.076412121,    0.080734606,    0.081236326,    0.074337539,    0.075076493,    0.072641451,    0.0733183,  0.084494256,    0.140352,   0.103880058,    0.105264,   0.082191749,    0.186437481},
{0.169064195,   0.297878374,    0.122468714,    0.392631649,    0.129376189,    0.069231301,    0.087155498,    0.075320809,    0.079760156,    0.070624286,    0.077746941,    0.068116443,    0.089833799,    0.106989909,    0.091869944,    0.070075149,    0.090094857,    0.076962476,    0.091360062,    0.072965753,    0.099107113,    0.076243305,    0.116910404,    0.080571953,    0.099589052,    0.076050366,    0.086695674,    0.062983831,    0.087650741,    0.07284006, 0.080581058,    0.067013536,    0.082701128,    0.066868427,    0.077672903,    0.072966206,    0.14264705, 0.065955109,    0.122566313,    0.075242535,    0.084184768,    0.067763849,    0.096457133,    0.079493,   0.08732433, 0.155350677,    0.087794468,    0.068634197,    0.13420441, 0.122221905},
{0.333934974,   0.136377606,    0.172547445,    0.095075428,    0.152663407,    0.091516233,    0.112968191,    0.072630516,    0.08774251, 0.068685315,    0.184259034,    0.084300354,    0.103585317,    0.074864616,    0.090404043,    0.073321717,    0.086044543,    0.081071446,    0.076893816,    0.096248056,    0.086192112,    0.121654875,    0.100589579,    0.072234957,    0.139895935,    0.075301945,    0.090002424,    0.078983471,    0.085511638,    0.067730587,    0.088544489,    0.070818725,    0.084701468,    0.084821782,    0.093630665,    0.087147782,    0.08685585, 0.075369744,    0.176781533,    0.067008139,    0.220618373,    0.062773951,    0.07908785, 0.075042176,    0.098812526,    0.076609094,    0.119200395,    0.155886998,    0.133470442,    0.196828614},
{0.101184107,   0.105529152,    0.118250001,    0.10704188, 0.10725461, 0.095005768,    0.078625457,    0.09693741, 0.102695261,    0.098090873,    0.104690152,    0.078478786,    0.382043261,    0.08679328, 0.096645895,    0.082747232,    0.10072819, 0.089330424,    0.089594443,    0.159960929,    0.08582656, 0.079470408,    0.077964741,    0.089218547,    0.080754436,    0.071806563,    0.156363863,    0.084099535,    0.088997485,    0.08803986, 0.084063808,    0.128547283,    0.078720885,    0.091162313,    0.097066191,    0.091154925,    0.097943424,    0.094527352,    0.088092299,    0.103905038,    0.088983959,    0.100419364,    0.112381914,    0.103258926,    0.07923088, 0.107222055,    0.132660662,    0.104523746,    0.111327871,    0.145343321},
{0.105054333,   0.157437445,    0.125703676,    0.104765181,    0.074121642,    0.118566575,    0.057993755,    0.10843684, 0.069268116,    0.070542245,    0.079795172,    0.072105819,    0.068758536,    0.072423128,    0.063130832,    0.058482433,    0.059776457,    0.055584303,    0.059314416,    0.069339743,    0.07675595, 0.145804168,    0.077291109,    0.07792404, 0.052877214,    0.050844879,    0.069256852,    0.058045344,    0.056174883,    0.060008302,    0.062427676,    0.067308004,    0.064746039,    0.071762999,    0.055858572,    0.070277508,    0.059651324,    0.061460322,    0.075433398,    0.067440512,    0.060898709,    0.061145052,    0.056093897,    0.072728301,    0.091525626,    0.088411217,    0.083683072,    0.102131996,    0.061327332,    0.091678981},
{0.08000000,    0.105263158,    0.076923077,    0.050000000,    0.057142857,    0.042553191,    0.052631579,    0.062500000,    0.048780488,    0.044444444,    0.042553191,    0.042553191,    0.066666667,    0.050000000,    0.058823529,    0.051282051,    0.055555556,    0.047619048,    0.058823529,    0.047619048,    0.054054054,    0.055555556,    0.062500000,    0.068965517,    0.062500000,    0.045454545,    0.080000000,    0.047619048,    0.048780488,    0.047619048,    0.080000000,    0.050000000,    0.040000000,    0.054054054,    0.040000000,    0.040000000,    0.071428571,    0.041666667,    0.047619048,    0.041666667,    0.052631579,    0.051282051,    0.054054054,    0.041666667,    0.054054054,    0.050000000,    0.048780488,    0.052631579,    0.050000000,    0.133333333}
}
};




double factorhan[2][10][50]=
{
{
{0.123261901,   0.073495942,    0.110166724,    0.100598115,    0.108575052,    0.083260895,    0.10360284, 0.073692172,    0.107906972,    0.080784653,    0.080784653,    0.087937011,    0.107170795,    0.071917154,    0.086566078,    0.091567153,    0.085791383,    0.088938638,    0.107150475,    0.096921078,    0.105041333,    0.082483443,    0.102446386,    0.080344481,    0.103487584,    0.085433422,    0.100583791,    0.09109997, 0.111064708,    0.080722917,    0.101939121,    0.067978011,    0.094600193,    0.077548234,    0.106158159,    0.107631581,    0.08964973, 0.085556943,    0.10052296, 0.080851688,    0.102124718,    0.068043695,    0.099868344,    0.078837509,    0.124708985,    0.08841337, 0.093110905,    0.066078716,    0.109742066,    0.162568591},

{0.103793733,   0.142784103,    0.142255382,    0.05712833, 0.076681246,    0.067374316,    0.064237431,    0.06489615, 0.103521249,    0.062551296,    0.062551296,    0.059289794,    0.069616113,    0.060060366,    0.065807849,    0.061851035,    0.129036618,    0.066069535,    0.058165858,    0.064736287,    0.069700484,    0.054768774,    0.088122454,    0.090817845,    0.125887339,    0.0647231,  0.071386661,    0.126991813,    0.067301906,    0.118137599,    0.068154981,    0.06129928, 0.067703577,    0.094616312,    0.114407738,    0.063927554,    0.064853804,    0.072384997,    0.065897013,    0.065531162,    0.058220023,    0.063055275,    0.065858163,    0.066745645,    0.061608419,    0.145097305,    0.078026128,    0.14038215, 0.068810611,    0.086437223},

{0.076069358,   0.093080178,    0.056541733,    0.20093839, 0.054200796,    0.104800155,    0.04216739, 0.099215588,    0.053892426,    0.140698309,    0.140698309,    0.096010536,    0.055519135,    0.105344,   0.047236663,    0.13457551, 0.050715916,    0.099630692,    0.049495881,    0.092264232,    0.052064296,    0.168591892,    0.05168506, 0.1155492,  0.052126973,    0.103926046,    0.05011782, 0.105964665,    0.047988021,    0.106367067,    0.046736883,    0.1224165,  0.045508835,    0.148996603,    0.050920278,    0.114408596,    0.048202944,    0.113139627,    0.053020901,    0.104715854,    0.049189159,    0.095961556,    0.047627349,    0.106940167,    0.045724707,    0.129044145,    0.054398167,    0.15705854, 0.066432137,    0.125469216},

{0.077832483,   0.116902134,    0.122823118,    0.093580005,    0.11463028, 0.065091601,    0.080897009,    0.078603891,    0.085581164,    0.072306599,    0.072306599,    0.071597219,    0.080109869,    0.066148867,    0.065742952,    0.065778884,    0.080900979,    0.065781508,    0.073476906,    0.065647587,    0.070891562,    0.072251362,    0.07183178, 0.068088691,    0.072678545,    0.074895148,    0.073291066,    0.077999275,    0.112929982,    0.066594953,    0.067513622,    0.071431996,    0.079688109,    0.077634466,    0.07679689, 0.065397104,    0.08659334, 0.090133967,    0.066182942,    0.074152116,    0.071686038,    0.074903654,    0.093285457,    0.060776527,    0.095313226,    0.081076013,    0.120503894,    0.126146454,    0.076110465,    0.074612268},

{0.097978918,   0.12022502, 0.20192626, 0.116928599,    0.286558245,    0.068058172,    0.069004008,    0.099064414,    0.068804453,    0.072592141,    0.072592141,    0.067527128,    0.091689413,    0.086148337,    0.069367255,    0.083623773,    0.060933571,    0.076484275,    0.078274605,    0.078469438,    0.081748203,    0.083402863,    0.072079753,    0.101380989,    0.082711795,    0.103902678,    0.081829911,    0.087606473,    0.06271028, 0.076619541,    0.07406629, 0.077114022,    0.073051588,    0.096762553,    0.076628676,    0.08305461, 0.072108358,    0.06996934, 0.068961354,    0.07245303, 0.059248976,    0.070083211,    0.07353798, 0.081760464,    0.079541702,    0.099275892,    0.17088922, 0.127922361,    0.071504311,    0.316509992},

{0.151544546,   0.076140089,    0.089529941,    0.102475908,    0.077541163,    0.066893038,    0.06152104, 0.130019833,    0.070411703,    0.068071805,    0.068071805,    0.077979806,    0.082929277,    0.077463503,    0.056887166,    0.077191016,    0.068642302,    0.073299627,    0.078630022,    0.07409295, 0.062727472,    0.063038124,    0.066926826,    0.13689529, 0.071854177,    0.076588749,    0.072849848,    0.128542891,    0.060099637,    0.07065473, 0.065165872,    0.121514892,    0.078586534,    0.081432076,    0.074161018,    0.076124953,    0.070471433,    0.079571658,    0.058496984,    0.087028338,    0.058805904,    0.074875057,    0.063610969,    0.075234374,    0.063491486,    0.072089238,    0.119701908,    0.1117668,  0.131736929,    0.088477024},

{0.1881202, 0.095525312,    0.275652157,    0.140656271,    0.161021547,    0.075875475,    0.144211925,    0.074491759,    0.130513133,    0.069726633,    0.069726633,    0.074963219,    0.118291127,    0.068870201,    0.11293427, 0.080590061,    0.101792336,    0.077051554,    0.131968089,    0.060449311,    0.125175125,    0.073709979,    0.23425935, 0.074162399,    0.122911191,    0.073521094,    0.119591584,    0.073043334,    0.102936958,    0.067233165,    0.120792494,    0.081965353,    0.127568452,    0.078573507,    0.128330007,    0.081814808,    0.122211034,    0.070568195,    0.205684772,    0.078782674,    0.247696629,    0.084159905,    0.123093972,    0.092462327,    0.25997651, 0.244393036,    0.122048788,    0.184063626,    0.162539499,    0.130298242},

{0.130594725,   0.104683626,    0.183261384,    0.089364747,    0.132723954,    0.076861138,    0.100131004,    0.087607019,    0.095247668,    0.068268211,    0.068268211,    0.088515671,    0.099780519,    0.076907051,    0.097462173,    0.071365806,    0.094410384,    0.095102916,    0.126929542,    0.095797794,    0.120955887,    0.076051711,    0.11710131, 0.064213952,    0.091038526,    0.073699929,    0.104107732,    0.077224478,    0.077950923,    0.062208259,    0.089677508,    0.088663067,    0.082005612,    0.081118356,    0.114007462,    0.079667224,    0.099623253,    0.081835778,    0.098385829,    0.091203454,    0.092698451,    0.078808625,    0.091747104,    0.084985973,    0.106160236,    0.104556105,    0.135674305,    0.131216036,    0.1629271,  0.094314579},

{0.114367404,   0.08616752, 0.087713494,    0.177970674,    0.082719814,    0.068046939,    0.070014704,    0.059849911,    0.06953885, 0.068754119,    0.068754119,    0.09909128, 0.071695349,    0.06046699, 0.064059104,    0.071861118,    0.129173362,    0.070860402,    0.062842548,    0.069206746,    0.074685749,    0.103574566,    0.072852186,    0.086896921,    0.067013153,    0.086721616,    0.065377967,    0.098146249,    0.066704682,    0.082001877,    0.063007045,    0.075083897,    0.126887389,    0.077180452,    0.060720755,    0.071610058,    0.067591713,    0.08031672, 0.067018595,    0.079395248,    0.096812595,    0.072748587,    0.110425729,    0.086194717,    0.095126462,    0.090454921,    0.092859643,    0.126459242,    0.119889538,    0.09200439},

{0.126915554,   0.100709851,    0.100204295,    0.173824186,    0.089782677,    0.074793627,    0.091285629,    0.085170355,    0.099208990,    0.082251172,    0.082251172,    0.121349965,    0.076661685,    0.067452381,    0.081615222,    0.068460392,    0.082244138,    0.069895136,    0.101909685,    0.118834203,    0.074772236,    0.073892415,    0.083463669,    0.102264976,    0.103168485,    0.114078129,    0.080584517,    0.060651613,    0.077912255,    0.099463672,    0.082245645,    0.094725474,    0.118829349,    0.097335613,    0.078338837,    0.075688575,    0.082789302,    0.065484621,    0.078431247,    0.073105826,    0.105753076,    0.066890897,    0.066350288,    0.063689817,    0.088342033,    0.070862072,    0.06890518, 0.079357193,    0.132235618,    0.074177998}
},

{
{0.145474684,   0.073951842,    0.130405327,    0.072923351,    0.127398989,    0.074896967,    0.124193406,    0.066012722,    0.117697766,    0.066443813,    0.066443813,    0.07075838, 0.122630344,    0.070860082,    0.107538483,    0.06899583, 0.112807744,    0.077168328,    0.087729114,    0.06207972, 0.093039141,    0.05987872, 0.149279866,    0.062648609,    0.094175977,    0.06975417, 0.17579842, 0.064821626,    0.234697192,    0.075496519,    0.148389092,    0.068429881,    0.120799877,    0.061409472,    0.103881253,    0.056777048,    0.142489214,    0.059529224,    0.096821116,    0.087218481,    0.08666665, 0.064149079,    0.097017203,    0.063675149,    0.100410608,    0.07099008, 0.130795172,    0.068760166,    0.224527312,    0.127442195},

{0.099272927,   0.125435063,    0.160695722,    0.092036422,    0.091558493,    0.058841335,    0.082848668,    0.06531866, 0.078240454,    0.065483796,    0.065483796,    0.074655236,    0.078395988,    0.055159546,    0.07071403, 0.068040078,    0.073210118,    0.060756353,    0.071407899,    0.051773397,    0.064024086,    0.063453701,    0.059491701,    0.065254542,    0.066194187,    0.069075051,    0.100984659,    0.064509533,    0.070876538,    0.067369003,    0.0752578,  0.058161147,    0.09319906, 0.066403056,    0.063053706,    0.074416357,    0.065027547,    0.077073876,    0.066279905,    0.075615444,    0.308796983,    0.06628059, 0.062960879,    0.117345772,    0.094867213,    0.098813164,    0.127596518,    0.102574352,    0.129578944,    0.529331192},

{0.122682251,   0.093607049,    0.0830302,  0.186335585,    0.086313886,    0.075542589,    0.071208299,    0.077323253,    0.088615965,    0.068644852,    0.068644852,    0.074441884,    0.078353972,    0.070592471,    0.075365597,    0.066652467,    0.07927146, 0.071468392,    0.081241662,    0.078972842,    0.082856076,    0.081063685,    0.074693581,    0.066818346,    0.081802114,    0.086830147,    0.076343838,    0.109576659,    0.07414438, 0.083540003,    0.076695622,    0.080633349,    0.072589213,    0.073068841,    0.071820008,    0.094561835,    0.08491589, 0.069623808,    0.079703877,    0.104820509,    0.077233018,    0.076498328,    0.088054189,    0.076120379,    0.093105745,    0.092419777,    0.090302151,    0.075922614,    0.085836927,    0.098655253},

{0.109150452,   0.115192619,    0.134170634,    0.092418357,    0.100796761,    0.078890006,    0.079621374,    0.071072026,    0.098653583,    0.077795447,    0.077795447,    0.068389174,    0.093703535,    0.062910576,    0.091098794,    0.092622171,    0.082142961,    0.073063194,    0.075160993,    0.075800512,    0.094186968,    0.075975348,    0.083069238,    0.08638088, 0.078939649,    0.115887533,    0.075455506,    0.081799091,    0.078452962,    0.083077035,    0.091173172,    0.069207646,    0.078460046,    0.084928372,    0.070125183,    0.081100232,    0.084935767,    0.071648208,    0.072054454,    0.076691447,    0.075892951,    0.080066472,    0.077142013,    0.079911987,    0.082661935,    0.068006744,    0.082982414,    0.075092501,    0.101599408,    0.181523597},

{0.117698189,   1.244498091,    0.114516712,    0.111626894,    0.107446945,    0.059755579,    0.066255659,    0.058644774,    0.066981454,    0.064226549,    0.064226549,    0.062373834,    0.070255844,    0.075275512,    0.069762004,    0.060168608,    0.059976031,    0.06613798, 0.065867126,    0.0817229,  0.078620487,    0.060002197,    0.068104459,    0.056665389,    0.07026187, 0.069257616,    0.066206188,    0.060119748,    0.069970162,    0.07411671, 0.05901711, 0.063092731,    0.076843033,    0.073669713,    0.072695653,    0.069433845,    0.060639351,    0.069341599,    0.070848249,    0.072173958,    0.062710344,    0.06604224, 0.063444754,    0.063143793,    0.07186304, 0.069633869,    0.087279334,    0.070947755,    0.071741415,    0.173744196},

{0.155362324,   0.217046401,    0.115636725,    0.336963435,    0.112907492,    0.061879415,    0.076936261,    0.066431412,    0.069313532,    0.062419053,    0.062419053,    0.059165003,    0.080633182,    0.091043722,    0.078598219,    0.062965833,    0.077806957,    0.067452493,    0.081161948,    0.062509677,    0.089818714,    0.069064451,    0.090217252,    0.070873996,    0.078981893,    0.064823431,    0.074993694,    0.051272007,    0.076327719,    0.065194153,    0.070385079,    0.059426407,    0.072134456,    0.056430804,    0.067158357,    0.063772325,    0.115552132,    0.055937452,    0.099262398,    0.066950383,    0.073373611,    0.059323184,    0.087049264,    0.058952468,    0.078083889,    0.131584812,    0.076627413,    0.059784311,    0.117880464,    0.118445633},

{0.289937603,   0.136908679,    0.167220376,    0.095819213,    0.153032706,    0.090679499,    0.106392658,    0.070912463,    0.08670764, 0.066695656,    0.066695656,    0.082109293,    0.088493769,    0.076171005,    0.089456316,    0.07269067, 0.080324122,    0.068486909,    0.068484469,    0.100280146,    0.085032726,    0.118601106,    0.104419489,    0.067172824,    0.13194663, 0.073437713,    0.080492013,    0.071643241,    0.075046768,    0.058002202,    0.07839901, 0.064192217,    0.076856507,    0.077641029,    0.088741746,    0.07911888, 0.07898006, 0.061596672,    0.158362504,    0.062541356,    0.205328035,    0.057365251,    0.072712662,    0.067812481,    0.091602152,    0.072822623,    0.118456014,    0.138365417,    0.122596644,    0.212143876},

{0.095790506,   0.104785726,    0.115672977,    0.106458289,    0.106254984,    0.091384031,    0.075679773,    0.089728452,    0.097695586,    0.097661128,    0.097661128,    0.07702281, 0.318492824,    0.087252218,    0.092655955,    0.080276056,    0.095839722,    0.080736883,    0.080859374,    0.165833961,    0.086102082,    0.076397224,    0.083632502,    0.086738667,    0.082884404,    0.072091353,    0.143246531,    0.080304795,    0.081882156,    0.079811113,    0.073925549,    0.117753258,    0.071594185,    0.084413725,    0.085448395,    0.084171153,    0.084838257,    0.085825401,    0.078447005,    0.102645625,    0.082174903,    0.090607935,    0.104745158,    0.101649406,    0.07181818, 0.103957411,    0.123655711,    0.094499933,    0.10794491, 0.156112408},

{0.097400504,   0.118849645,    0.129123999,    0.123168802,    0.084597877,    0.12790516, 0.063728605,    0.092126242,    0.076303666,    0.085634109,    0.085634109,    0.079881821,    0.06846323, 0.077887764,    0.069652207,    0.063527832,    0.069283476,    0.061543418,    0.069884664,    0.072846615,    0.086988056,    0.116992383,    0.080520701,    0.081481369,    0.064647954,    0.062760385,    0.071406569,    0.066228687,    0.061907535,    0.066877989,    0.066244542,    0.074934608,    0.07034958, 0.077604309,    0.063525633,    0.078326264,    0.06493246, 0.067204005,    0.08355237, 0.076178292,    0.066051898,    0.070406974,    0.063863433,    0.090978099,    0.103009183,    0.099443242,    0.095526555,    0.113530209,    0.071039773,    0.135681679},

{0.097534837,   0.096764285,    0.118050125,    0.075789461,    0.110124967,    0.067242993,    0.083406106,    0.053774847,    0.067636666,    0.06068391, 0.06068391, 0.063746129,    0.065939735,    0.057189641,    0.066757665,    0.069111377,    0.080102995,    0.078669358,    0.069194058,    0.052912372,    0.063857936,    0.055485401,    0.057636912,    0.08308307, 0.054443789,    0.05801342, 0.133536791,    0.067104736,    0.066043145,    0.075497678,    0.123928857,    0.067841028,    0.078039197,    0.068080086,    0.082187896,    0.062902347,    0.078451217,    0.071289522,    0.067337632,    0.058225962,    0.069822662,    0.075437848,    0.067565156,    0.076884938,    0.092847643,    0.075171015,    0.074335741,    0.090840673,    0.078433037,    0.200803576}

}

};


double factorhanmodified[2][10][50]=
{
{
{0.065357034505329, 0.044153495611862,  0.094869082872084,  0.065880598934235,  0.124969884852,     0.05282354265843,   0.1174317470832,    0.059357644394732,  0.10432500006446,   0.052742361112028,  0.069196498450415,  0.052502176858473,  0.1712203489238,    0.056552701302286,  0.049775841114312,  0.047593950681963,  0.046005972299282,  0.051286198786786,  0.11384416517325,   0.050071948842828,  0.089154041466416,  0.066155268074049,  0.14494524476824,   0.058519545492198,  0.095011019482144,  0.050387094494004,  0.11872810105849,   0.04896960457389,   0.14861346448064,   0.045383957672823,  0.13713666069888,   0.049457197969017,  0.049011792392142,  0.045639772348956,  0.085859975892087,  0.13389906834305,   0.05883909009306,   0.052687847752146,  0.09750053616168,   0.075408590660464,  0.16078617726638,   0.08384956491155,   0.0549275892,       0.057855852029758,  0.15732412584705,   0.06889868256023,   0.05093855524197,   0.12417578389436,   0.093077404051702,  0.109100431694464},

{0.088396244090649, 0.139256764519488,  0.127845480824928,  0.05207527208317,   0.06910437208274,   0.062243222842072,  0.056515963318938,  0.0594718701984,    0.095457461309145,  0.055322618029056,  0.058447180366848,  0.052332907441422,  0.063814584607032,  0.055226287321758,  0.059492203923621,  0.054012467781345,  0.118128894607224,  0.059713579663465,  0.05180949303776,   0.057774805641168,  0.063658636945428,  0.052176184545162,  0.075639115288814,  0.083613901081065,  0.111964576968617,  0.0579143593262,    0.061038950328067,  0.122981792520899,  0.056939969948428,  0.116917119464731,  0.059464880147595,  0.0544239527552,    0.05790822347964,   0.08719981238388,   0.108349161826472,  0.057607100663574,  0.055923046066376,  0.066674327431679,  0.058593844740249,  0.060186571489604,  0.050147583930958,  0.0568173427548,    0.057738114934752,  0.061192607572935,  0.053471055801642,  0.13709780038074,   0.068755687680064,  0.14366709231,      0.059934110991611,  0.074525827921708},

{0.075295048004918, 0.09927373304412,   0.06454747697547,   0.2734188766569,    0.06170652223008,   0.1103084511468,    0.0448808615465,    0.11286566859704,   0.0564361485072,    0.16092087695257,   0.0139566531802404, 0.10015627094448,   0.06509785136155,   0.11776511104,      0.0549693047331,    0.1623195971416,    0.05382835176492,   0.10123275352736,   0.05222409396072,   0.09802982385768,   0.05207054371552,   0.17462916765252,   0.0532185557302,    0.134219639736,     0.05277074111655,   0.11766714780212,   0.0511412258844,    0.11758157122395,   0.05110916188584,   0.11744838804006,   0.0496298960577,    0.142202678895,     0.0556254490205,    0.16418382674379,   0.05444599804872,   0.12103170962244,   0.05853910128192,   0.12485070979077,   0.05694232683796,   0.1107527229831,    0.05442190173442,   0.10198218402344,   0.05016445788123,   0.11806087496633,   0.0482944355334,    0.14236279120545,   0.05688144332355,   0.1772923917082,    0.0734407274535,    0.15350154823872},

{0.08156766385917,  0.13387983092082,   0.14255710836906,   0.1083151125873,    0.1246764777392,    0.07180970513921,   0.09005940423934,   0.09597849506664,   0.0979091306742,    0.08039553823013,   0.08586842470844,   0.08116833523592,   0.09069879148442,   0.07765612390332,   0.07223309622144,   0.07838014480788,   0.08737791137874,   0.0755303274856,    0.0847519372257,    0.07544942821497,   0.07830894613206,   0.08468365385934,   0.0770015132066,    0.0806646722277,    0.0787094106641,    0.08376423142616,   0.08545151967072,   0.092959535945,     0.12877179987496,   0.07622258535521,   0.07689328950446,   0.08303040919052,   0.08766010742436,   0.08814151462844,   0.0855709346825,    0.07339909364544,   0.096698782778,     0.10467978659446,   0.07311626700392,   0.09011632505364,   0.07851986800254,   0.0840119383264,    0.10401515026414,   0.06795848919559,   0.10728647345012,   0.08858851636458,   0.13530056714426,   0.15236473299936,   0.08112995016675,   0.08021639544948},

{0.1157326979416,   0.1511336703918,    0.2627101027852,    0.1508612784298,    0.35655582750615,   0.08069044930492,   0.07664482180584,   0.12089226698076,   0.08717868217365,   0.08714178382063,   0.08034280389457,   0.08268629296472,   0.11013182153082,   0.10013279654521,   0.08141426617585,   0.10142811050943,   0.07039899191914,   0.09086714291375,   0.09398510096955,   0.09520226095912,   0.09680867443869,   0.10022105032395,   0.08251473884181,   0.12343743696684,   0.09503006262935,   0.12576691853154,   0.10416374860923,   0.10919621220612,   0.080043401392,     0.09242155513584,    0.0847199851536,    0.09561444701802,   0.0843453635048,    0.11437140239494,   0.09782340149484,   0.1012958939943,    0.08486144219588,   0.087521148939,     0.08413423110708,   0.0878869744506,    0.06967324083744,   0.08281662960659,   0.0908547035304,    0.09511521818976,   0.0914570489596,    0.12624716633856,   0.2284805960322,    0.15966757410576,   0.07850958834867,   0.44389260338032},

{0.1591217733,      0.09426219158289,   0.09132053982,       0.12091542288552,   0.07986739789,      0.08957914290732,   0.0912246285328,    0.16274712516443,   0.08467218520859,   0.07801233068415,   0.105456840306,     0.0935211813358,    0.08458786254,       0.091097079528,     0.07176714201062,   0.0900510392656,    0.07878832065862,   0.08783567603037,   0.10368626481052,   0.0777975975,       0.07469524638288,   0.07870057628904,   0.07919919808362,    0.2093046846926,    0.0843424329626,    0.09572215027518,   0.09088528486936,   0.16216456956996,   0.06972279087644,   0.0839427650711,    0.08018725715472,   0.158394661722,     0.08819688124286,    0.09967856126932,   0.08510421781608,   0.11267939418107,   0.08273205291334,   0.1137277921965,    0.06592668593784,   0.1155910385316,    0.07646472891216,   0.08771912427778,   0.07689484765627,    0.09109678941416,   0.08051545814118,   0.0756936999,       0.14040555000768,   0.157382184084,     0.15879174210873,   0.0987492064864},

{0.189060801,       0.0915801166144,    0.275652157,         0.14837267402706,   0.16685857807875,   0.07135891147515,   0.1499313699455,    0.066944328469879,  0.126868031708443,  0.069488934908103,  0.069866086266,     0.073613056462591,  0.12483617505691,    0.064472425444944,  0.1171060619338,    0.076193470222145,  0.1036449565152,    0.074689769766792,  0.130965395459778,  0.06194482695414,   0.1245327262585,    0.07612987761057,   0.26818010388,       0.07568124493152,   0.13158380463696,   0.069746300470758,  0.12288991988672,   0.07710746510376,   0.11056767469654,   0.081338683017,     0.13198633441898,   0.079977775155103,  0.125693706029408,   0.075805283774883,  0.12857511731337,   0.08391826671368,   0.118949099291506,  0.066682921887885,  0.21586822506172,   0.077124377494974,  0.27342487785423,   0.076066836055485,  0.12854211120072,    0.090443412089955,  0.2830286271417,    0.36223691402884,   0.119947596065792,  0.2226893779161,    0.157555387802664,  0.13988428366394},

{0.129949978842675, 0.099647610804018,  0.183261384,         0.09038707970568,   0.12046955132718,   0.072289130067208,  0.1091528074604,    0.084677615498678,  0.10406474462676,   0.068219672301979,  0.09012837484431,   0.086812718005631,  0.10588010212647,    0.07178119605085,   0.095089261473969,  0.068482841535018,  0.0991922699496,    0.09038200724976,   0.12053546632175,   0.095724317092002,  0.119380073704164,  0.071199231579645,  0.1222034140767,     0.063319965360256,  0.09374054945168,   0.0743042684178,    0.11206885026604,   0.08042466036832,   0.0824019207033,    0.07247324381759,   0.09634592749488,   0.08866750015335,   0.08527845597492,    0.08058621958464,   0.11134937802347,   0.08020816445096,   0.097706900105292,  0.07670017375161,   0.0989958211398,    0.090171851731806,  0.09438741677722,   0.07401075591,      0.09870520436736,    0.082477951950797,  0.105812667387336,  0.09188934199146,   0.121700529956525,  0.125816233686528,  0.167008423855, 0.093746427976104},

{0.11920400151516,  0.09950194372,      0.09801632100524,   0.2275977964449,    0.0938993968621,    0.07569745635177,   0.08107562693792,   0.06458224346277,   0.0861815829705,    0.0759870523188,    0.07977471673451,   0.119489219988,     0.08303325149086,   0.0669000730661,    0.07240856761536,   0.07667293846128,   0.14445327899098,   0.07712020991268,   0.07068341271396,   0.031110785356364,  0.0819750781024,    0.11221682778704,   0.08010680668188,   0.09665979007435,   0.07760592209471,   0.09265164010208,   0.0713535131838,    0.10859391720605,   0.07077633578928,   0.08758784486124,   0.06794490711665,   0.08250669105742,   0.14314800790035,   0.085226514121,     0.0680473212983,    0.08062719650336,   0.07414405365822,   0.0890985501648,    0.07763098951825,   0.0859532954848,    0.11116699846065,   0.07800685486836,   0.13582806369916,   0.09442372663199,   0.11237574335446,   0.0966691740727,    0.10046856214742,   0.15049408553452,   0.13924930059624,   0.0963534375153},

{0.111549380215004, 0.095978804329573,  0.100204295,        0.2174366742674,    0.10577476742724,   0.071378923959315,  0.089042375952954,  0.0823869877986,    0.1043529761315,    0.081223937112892,  0.08394636865492,   0.1317593649977,    0.072837723490515,  0.067352686380882,  0.077032200823812,  0.06868357287792,   0.079953392024286,  0.066853788947232,  0.101004013629405,  0.101004013629405,  0.068638445164212,  0.072400157679075,  0.08687232524196,   0.101403700372128,  0.1003024644867,    0.11784612960087,   0.08109703452812,   0.05720599486547,   0.07305084193702,   0.10197910826488,   0.076272884014455,  0.093293603735016,  0.12162421528848,   0.09997535482456,   0.073033887636034,  0.08174441788575,   0.079237972101408,  0.062149227313986,  0.075688976879892,  0.07117912195577,   0.11030468839104,   0.064409512284888,  0.063878275319984,  0.061572703793103,  0.084883354066017,  0.070320898356136,  0.06427206460198,   0.08378373722554,   0.1329232432136,    0.06698940821382}
},

{
{0.15778620650692,  0.075356926998,     0.14285512356869,   0.071057388294612,  0.13406960006404,   0.07502129596522,   0.13021554425694,   0.065339656286488,  0.12468548236742,   0.066183685472105,  0.06777268926,      0.0709020195114,    0.12701805770832,   0.069784567675404,  0.107098973219979,  0.0690703454964,    0.11580053344832,   0.0787657123896,    0.08833795405116,   0.05909325090996,   0.09549723510522,   0.0613331741088,    0.15070101032432,   0.06407198539648,   0.093860864180958,  0.06955083659445,   0.1896618834012,    0.06550419772178,   0.26333259639592,   0.07621147103493,   0.15403232916876,   0.07025832742032,   0.12384161790286,   0.06192776794368,   0.10870757601438,   0.05908389946024,   0.15902223750042,   0.06659950993448,   0.09912255392732,   0.09012721734135,   0.088965049558,     0.06504331716126,   0.09984816498354,   0.06453731051746,   0.10420010434592,   0.075820954944,     0.14333450513964,   0.06664200908637,   0.24493459938768,   0.11786287497063},

{0.10943152561991,  0.1379785693,       0.17932196313702,   0.1012400642,       0.09796941867986,   0.06036944446995,   0.09121141254792,   0.0673977529478,    0.08232695291242,   0.06905790158568,   0.07115993143728,   0.07837082709572,   0.08528072366616,   0.056979811018,     0.0752701349529,    0.0700166422659,    0.07852444046562,   0.06204378012007,   0.07464838945662,   0.0531091506426,    0.06925549406706,   0.06654960707179,   0.06279468023952,   0.06692440572978,   0.0671473832928,    0.07106095871625,   0.10864333553856,   0.0675479320043,    0.07791528698878,   0.07203834859793,   0.0791335767,       0.06252614108235,   0.1014108291766,    0.06954259248768,   0.06644473430868,   0.07809178087223,   0.07298756902827,   0.081775382436,     0.07003466161825,   0.08087222966688,   0.53089303708309,   0.0695946195,       0.06584133921425,   0.14011554559888,   0.11263489332277,   0.10761346438584,   0.1410388111713,    0.10660962700768,   0.13528300911488,   1.04788520093088},

{0.13120253333195,  0.09945468135103,   0.087623430664,     0.19399956761105,   0.09017384298192,   0.07961508997299,   0.07599136044383,   0.08467128173259,   0.10248347736285,   0.07420439856348,   0.0720770946,       0.08050740870832,   0.09023478477436,   0.0791412192381,    0.08326165059769,   0.07222261366719,   0.0853571299842,    0.0816740783776,    0.08960305385304,   0.10031446282208,   0.09264469281864,   0.0885685609573,    0.0800565801158,    0.07185711747186,   0.08539486284688,   0.09552965942793,   0.08430726374178,   0.11416572947892,   0.082500451626,     0.0926709253279,    0.08438282419306,   0.08730011429532,   0.08619460919259,   0.08320421993511,   0.08611721699256,   0.10289556951855,   0.0972210516199,    0.07757206192128,   0.08527756911861,   0.11808449620886,   0.08426431195872,   0.08511892458232,   0.09746542072032,   0.08827299750735,   0.1024032846957,    0.10249445689077,   0.10024261178208,   0.08255293588062,   0.09089615547738,   0.090962412336819},

{0.11792723984532,  0.1267118809,       0.15845954387302,   0.1265576980758,    0.11403238368691,   0.08644293517444,   0.08926670724636,   0.07796743396252,   0.12260272680908,   0.08320300852097,   0.08372034824352,   0.07672786598582,   0.1040840126073,    0.07097948647776,   0.10771157007384,   0.10808729489187,   0.09080822195589,   0.0797375167719,    0.08358353387558,   0.0820995345472,    0.10610915440944,   0.08336471034648,   0.09615845783166,   0.0940005374248,    0.08798850096487,   0.12687946550505,   0.08609322323588,   0.09209677856599,   0.08843531688488,   0.0923384628618,    0.09999052946412,   0.07761845121838,   0.08896427695848,   0.09452782588716,   0.08238586999572,   0.08985824605368,   0.09682082887631,   0.0766134288144,    0.08684867449528,   0.08500556676927,   0.08710689343976,   0.08827328538,      0.09461699320489,   0.0879031857,       0.09299219701695,    0.0740015384836,    0.09850925348354,   0.08015673926744,   0.11293485395056,   0.169991221358993},

{0.14273494776408,  1.3689479001,       0.15137277059008,   0.14667550617812,   0.12353282713595,   0.06950888460438,   0.08362855534639,   0.0680103444078,    0.08267788793036,   0.07421056604205,   0.08811625616604,   0.0713837343213,    0.0853678760444,    0.089540221524,     0.08521917122628,   0.06714876821408,   0.06985288378508,   0.0779753556604,    0.08093488974376,   0.0961878533,        0.08946382456704,   0.0761247873339,    0.08082977716415,   0.06791233540872,   0.0818599968809,    0.0767616786936,    0.08058683409548,   0.06997397589468,   0.08498505906358,   0.0837807878169,    0.0697965851415,    0.07760721376655,   0.09287479497479,   0.087519619044,     0.08888642883616,   0.08147020203075,   0.0724943441205,    0.08343250533279,   0.08249145024066,   0.08618869716444,   0.07776647049096,   0.0794877796416,    0.07405398576388,   0.07537348282824,   0.0906113885056,    0.0765972559,       0.1016236925429,    0.0780425305,       0.088155850752,     0.20197415296608},

{0.16655151857448,  0.35538092467735,   0.1349827490925,    0.37164708136455,   0.14400334437172,   0.0720251638834,    0.08969921733729,   0.07545545500608,   0.08428248237072,   0.07507826113893,   0.08036702749962,   0.07202806630223,   0.09660419635874,   0.10831653693784,   0.09903847183314,   0.07135728956391,   0.09313414945943,   0.07951569684812,   0.09435076455,          0.07624492832721,   0.10980247967786,   0.07874659638569,   0.11622869009664,   0.08507147487872,   0.09789568691671,   0.0790521741045,    0.09981360696624,   0.06187095628704,   0.09387240848934,   0.0756317368953,    0.08050504565862,   0.07145609456901,   0.09924474859848,   0.0656318465922,    0.08181633999882,   0.0753061876995,    0.15773097122264,   0.06624336815648,   0.12941235876852,   0.07712081568153,   0.08732560313165,   0.0693458359368,    0.10342845351424,   0.17440321275716,   0.09945310690263,   0.16502840781792,   0.09147244172049,   0.07431428994544,   0.14797298884992,   0.15320468846018},

{0.282116826096678, 0.121605574496096,  0.19481006583624,   0.090507762384984,  0.14562133204842,   0.083424050926012,  0.10566067651296,   0.06744838918245,   0.08402221768156,   0.058731727804008,  0.10466082426488,   0.076151853246385,  0.09884400022224,   0.07242278218596,   0.082462531758804,  0.06469789468948,   0.08228162085314,   0.07684299676709,   0.06916657431124,   0.08996332457952,   0.08047242090462,   0.11750582478609,   0.094143358248532,  0.0686271156396,    0.12991927003005,   0.07004195315088,   0.08724448797057,   0.07556355914752,   0.0813094207896,    0.06066276300574,   0.0823072006485,    0.064134058851398,  0.0799230816293,    0.077274485702091,  0.08975961382662,   0.0805675466928,    0.086412083646,     0.07040006836224,   0.1653621266768,    0.060693509095624,  0.20390141581282,   0.057205890332722,  0.07179066544584,   0.08798533784788,   0.09633706723688,   0.07320494177075,   0.103956050238288,  0.14663275066575,   0.13606756324272,   0.212143876},

{0.0909626644976,   0.11209138681672,   0.109250119279098,  0.1130374112602,    0.100978680259512,  0.088261530044761,  0.07436067455661,   0.09717860536956,   0.09869305793306,   0.093713274561728,  0.094780320046256,  0.07042472800416,   0.32444226995232,   0.081730548636088,  0.08738809333443,   0.076229099188872,  0.1010102750019,    0.08586044559518,   0.077295982247194,  0.156484076444859,  0.07579394074296,   0.075038040987816,  0.071434450685794,  0.08685402942711,   0.077786847385192,  0.066979066793358,  0.14577339980684,   0.075849404668605,  0.08332819487496,   0.07869136308461,   0.07726328753735,   0.12217842543564,   0.0716557559991,    0.08608764916675,   0.0869762123026,    0.08436053809425,   0.0929572781949,    0.08738399028216,   0.0824070098124,    0.09693298538625,   0.08456783617536,   0.090521585637945,  0.11194952996724,   0.091453157382952,  0.074482634478,     0.101380722610954,  0.14078450008772,   0.09484391275612,   0.10225027627295,   0.13585994531016},

{0.12614436673544,  0.2050227686037,    0.22458795394068,   0.21095243887342,   0.12165428506231,   0.189913581568,     0.0985218741858,    0.15636955559628,   0.11962736148148,   0.13005423402048,   0.14039284000005,   0.10912975094094,   0.1233495168587,    0.12214437038244,   0.09635547011966,   0.09367369411896,   0.12175808788764,   0.08506900496468,   0.10359982130016,   0.1047228367917,    0.112084110156,     0.16563313615608,   0.09498946576269,   0.11957961270333,   0.07781092391394,   0.08398029877235,   0.11043097302419,   0.09267777544032,   0.09561680688285,   0.10606247153499,   0.09839368067802,   0.11217411079168,   0.1074596869458,    0.11603784303225,   0.09145658331744,   0.11629257068608,   0.1015491728432,    0.0948974313804,    0.1533085726656,    0.12254116229412,   0.10274504837696,   0.10459730464414,   0.10708428855141,   0.090978099,        0.13957126241402,   0.14083450261766,   0.15803817732645,   0.18234540988326,   0.11071619661823,   0.1465769178237},

{0.13605329482804,  0.14558864028245,   0.1482544299825,    0.13766549274962,   0.28859128602086,   0.13902757774722,   0.14095882132318,   0.18039794148243,   0.1896024839645,    0.143268643119,         0.06068391,         0.14279515372774,   0.2444583795655,    0.15190369304574,   0.16078116311595,   0.16367163635271,   0.14334671264235,   0.14161979157802,   0.1613674626618,    0.079368558,            0.25296171903552,   0.17805709064108,   0.21115628532672,   0.144431608888,     0.13257389284234,   0.1783251312012,    0.16697573883431,   0.16053264679072,   0.14163282660975,   0.13680481244312,   0.19463894493849,   0.14878487214792,   0.13965036263953,   0.13793161583772,   0.15007591997496,   0.15063728254866,   0.15368750312734,   0.13797302798358,   0.16289713894752,   0.16836095138262,   0.15545107999694,   0.1495442179828,    0.14280165981224,   1.287246074465,     0.14450992851806,   0.14100503822685,   0.14935388410238,   0.13742104489421,   0.13193456452881,   0.194925252116176}

}

};





double factorzhangmodified[2][10][50]=
{
{
{0.073386672527015, 0.0320112426191523, 0.0782635134677636, 0.043947174106875,  0.109473936658209,  0.079232226783931,  0.0800157043757957, 0.069007897765508,  0.0838272721586908, 0.0745187768027588, 0.1012072212419960, 0.0708324340410462, 0.0731331778767765, 0.0718985737111744, 0.0614673338065398, 0.0596253564156262, 0.0499271196237398, 0.071814042174458,  0.0745897644662671, 0.0712572127567084, 0.0667400276216792, 0.092394634449929,  0.0624050202298077, 0.0648563369351206, 0.069944409615614,  0.0732014007016996, 0.0728856576075065, 0.0484946567276471, 0.0835929051842105, 0.0357070365869786, 0.0871568253303926, 0.0615368939739456, 0.0638985117366662, 0.0515072263454316, 0.0942912922967821, 0.0550725736447118, 0.101389861414387,  0.0750014481731734, 0.0761447125795228, 0.0769374363392296, 0.0687743243875254, 0.118645753252363,  0.0970035270267491, 0.0797634480339837, 0.0815416167935813, 0.108229940935002,  0.132042116800449,  0.0378967879336158, 0.0724319982071163, 0.117399813777108},

{0.08639197235106,  0.136877199242253,  0.126358960924045,  0.051761911300885,  0.0693181400806593, 0.0645064252329228, 0.0554394144508562, 0.0589576787271272, 0.0964540715367914, 0.0550890238401684, 0.059220914682602,  0.0521383961811271, 0.0636946689859549, 0.0553796544792059, 0.0595091985852021, 0.053984971732751,  0.119228399728827,  0.058662875001156,  0.0517480913698429, 0.057745750778194,  0.0636832499938091, 0.0518852334652868, 0.076032668846782,  0.0949354712986429, 0.113802219367504,  0.0561626909103,    0.0606663375329275, 0.122788793009562,  0.0573052459345339, 0.123323073122945,  0.059078581995746,  0.0545856770401296, 0.0561419444786166, 0.0936034430380809, 0.110519000905325,  0.0575688108067615, 0.0541828692353536, 0.069813842116209,  0.0582995514052741, 0.0622747511072839, 0.0499112656958541, 0.0573536479906344, 0.0562240280364892, 0.0621226539220432, 0.0508694867593356, 0.143076866715576,  0.0682744231549059, 0.147376149462483,  0.0590527157256269, 0.0720224743629092},

{0.076786790161927, 0.100684089275606,  0.0623237994336918, 0.280702217199935,  0.0634070236962817, 0.111135745155653,  0.0517429861060196, 0.112017638723299,  0.0567991963186209, 0.16646570764953,   0.0595791260147182, 0.103893093883661,  0.0612415678157178, 0.119926029774955,  0.0567505654413405, 0.151961737708978,  0.0559067127945903, 0.102253500210969,  0.0552911717146012, 0.101549960219264,  0.0522649472634122, 0.176789765336409,  0.0535364536950025, 0.1407238493507,    0.0527749807835624, 0.117969090617532,  0.054015262705618,  0.120612760098401,  0.0534467580148414, 0.124064236700672,  0.0504557275900932, 0.147173962917011,  0.0532620350520763, 0.163175842954837,  0.0558427369448797, 0.121902677240204,  0.063530425969151,  0.128631620410349,  0.0576721765597431, 0.116328628033015,  0.0540151356386427, 0.108083423446725,  0.0504844656676399, 0.119714165962067,  0.0496559127272727, 0.150408149762555,  0.0578984166752419, 0.181560575597232,  0.0723520214590519, 0.146104912846274},

{0.080534663236767, 0.132214601468405,  0.141620184601817,  0.105115867381139,  0.122703892392671,  0.0708555608923736, 0.0886801639566699, 0.0942666712990282, 0.0983450284709016, 0.0783181768306361, 0.0882334434899029, 0.080445839000955,  0.0899496829471573, 0.0768795218019202, 0.0720999934654689, 0.0783194927537824, 0.0859430576633359, 0.0743417467045035, 0.0828854708566168, 0.074126392274778,  0.0777548874347743, 0.0839067532698499, 0.0774400132416633, 0.0810520552987964, 0.0777476132581849, 0.0830993020376208, 0.0825649944896683, 0.094149528396182,  0.129412140546891,  0.0752731639517236, 0.0755606777569754, 0.0821660690583338, 0.0877099707780818, 0.0873937811394959, 0.0843629366716744, 0.0735137919650384, 0.0946629741408909, 0.102899624452926,  0.0728770821956038, 0.0866065404364474, 0.0770930541726745, 0.0834169452187903, 0.100357207888478,  0.0674593607704618, 0.106972827788101,  0.0904116936428423, 0.124030393588651,  0.142605894351683,  0.0788016694484913, 0.081457162192463},

{0.108893326269917, 0.143601548177399,  0.279275418639898,  0.138531392651515,  0.354269450769231,  0.0805327566711079, 0.0828286616467477, 0.124160677931858,  0.0876964119859063, 0.0826863454200856, 0.0776145091292232, 0.0823193063614508, 0.103667727876023,  0.0990116178905414, 0.0783629195444278, 0.102888670274508,  0.0710113088177563, 0.0898126125276783, 0.0928535760731992, 0.098491586153336,  0.0948872397737673, 0.0993801832125255, 0.0822632009419152, 0.119450128549243,  0.0957210918060692, 0.120499390276384,  0.103411299079461,  0.105596894527851,  0.076158054345364,  0.0943654790179804, 0.0842561164444971, 0.0925197105110656, 0.0836229981967934, 0.112961262892384,  0.0912799693753922, 0.101581017538697,  0.0830665087649707, 0.0842915471740842, 0.0820541080894514, 0.0868792527545057, 0.0676282926230219, 0.0820443175695996, 0.0940770286072621, 0.0943653538411755, 0.0914135084349993, 0.13096146438722,   0.228700462463488,  0.157533112149611,  0.0728462042824282, 0.453189108212966},

{0.196342601413907, 0.0921789140080215, 0.148451930559012,  0.125756560975753,  0.110958432883407,  0.0887951952493556, 0.0885778717136593, 0.168084467299416,  0.0850254076253789, 0.087120163377165,  0.115886928315329,  0.0960547640000675, 0.0956739183474458, 0.0991105140660206, 0.070608470085656,  0.0930372235779598, 0.0845270473233184, 0.0900611915214221, 0.096854802571718,  -0.052040173768061, 0.0791132828672412, 0.0823884950978153, 0.0820145427387211, 0.190218332853501,  0.0913565371675425, 0.100436773623448,  0.0919633353548048, 0.162844734905681,  0.0736807506068757, 0.0905354770934199, 0.0824617854517992, 0.158927909835969,  0.0903597657119031, 0.0986131915491535, 0.092774912374129,  0.0996134151697845, 0.0851061108479221, 0.107846362234249,  0.0684625157852785, 0.110909797756556,  0.0751418977451314, 0.0941941731567643, 0.0801254828387066, 0.09492188769956,   0.0783698891988602, 0.092798981835899,  0.149897738634928,  0.174486337309584,  0.17773243797432,   0.110179296074853},

{0.243150954557677, 0.103585007593838,  0.278623156023376,  0.152255881508526,  0.23013746445688,   0.0711246403100488, 0.158433412431441,  0.0656087260593821, 0.128850581401207,  0.0691440952926378, 0.121926328039522,  0.0723222740151415, 0.126743778833792,  0.0640926917178537, 0.116385740202051,  0.0757846617932416, 0.103095447844339,  0.0742295536076443, 0.13316991876829,   0.0670428979721406, 0.125485315240293,  0.0755304187173947, 0.297118907301233,  0.0752098017088209, 0.131591606809197,  0.0696161936827538, 0.122051532974992,  0.0768438579467357, 0.110338752488604,  0.0824150904084566, 0.131647573120817,  0.0800080957437675, 0.127516258163122,  0.0758250763901313, 0.128828766792453,  0.0834078334977537, 0.117182261204243,  0.066644852171162,  0.219806680674869,  0.0769723197470576, 0.259509740870111,  0.0757841414485776, 0.126882372237306,  0.0879690181184313, 0.301566246348524,  0.266883190394985,  0.117946075607041,  0.207708695153537,  0.154853668284027,  0.130504676740431},

{0.176543672158577, 0.093342037303419,  0.282068709037599,  0.0821330075066727, 0.128874842401254,  0.0693598235570304, 0.110562581678371,  0.0804088754918623, 0.100601199335447,  0.0651053055328936, 0.0930569025140682, 0.0817073958806557, 0.105524187032643,  0.0686183305632711, 0.0953360589489308, 0.0683223004648447, 0.0991138013240514, 0.0856457040430834, 0.119082015657599,  0.0843531402699422, 0.117448418375883,  0.0692555306932155, 0.102877235200966,  0.0633460762058688, 0.0920258476740431, 0.0757010367952146, 0.110453395131032,  0.0781792621282909, 0.0789809963282261, 0.0713049444978956, 0.103227067529126,  0.087025127887463,  0.0812271832561601, 0.0775628667530326, 0.110561262195498,  0.0782873841146113, 0.100082279558279,  0.0740375228681392, 0.20756054224274,   0.0875236745224216, 0.262258269815736,  0.0745878057206757, 0.0981926863933056, 0.0801997380754877, 0.283917256195478,  0.265015424935015,  0.120624340075284,  0.121104292278204,  0.153025505070267,  0.095525322681993},

{0.112628890240868,  0.0844550121187652, 0.0914236807636601, 0.202688075935429,  0.0845478670691487, 0.0693151746458592, 0.0732874780790827, 0.0576172011566592, 0.0766022390305191, 0.070895523426471,  0.0728106345464831, 0.105404709601348,  0.072664171884984,  0.0614555665981434, 0.0682010609066663, 0.0710774318527673, 0.227244908347256,  0.0656181877145461, 0.0669123322298818, 0.050407811251774,  0.0758864719302023, 0.104044090178364,  0.0720712209163329, 0.091656669968552,  0.0669766839942956, 0.0829363590903058, 0.0639221956309715, 0.101604546998308,  0.0654007402800509, 0.0803601427244107, 0.0626999426566943, 0.0792785273480019, 0.137956203360724,  0.0762080239162873, 0.0625360364304004, 0.0701981241103886, 0.0679535385508593, 0.0830199993660137, 0.0699526066275862, 0.0790653933781297, 0.102613467314127,  0.0688874241890065, 0.153949900424639,  0.0799360110952602, 0.104442728313974,  0.0861886345631495, 0.0957213261935733, 0.135534322174633,  0.123176680680201,  0.0901869957524407},

{0.103890704761905, 0.08889672,         0.07857142857186,   0.122222222222222,  0.0733333333333333, 0.0704905142857143, 0.0885043076923077, 0.0799648666666667, 0.091671724137931,  0.0830005,  0.0812929333333333, 0.145746333333333,  0.0688056470588235, 0.06152685,         0.072778,           0.06224515,         0.0817785833333333, 0.0702397666666667, 0.10331211,         0.1033121122554445, 0.068218975,        0.0726680625,       0.084118,           0.09545096,         0.0931755,          0.119776066666667,  0.09975328,         0.05558575,         0.0664338888888889, 0.0822096,  0.0759751142857143, 0.0952608148148148, 0.118414,           0.1084336,          0.0856720526315789, 0.0643002105263158, 0.0720952941176471, 0.0591024210526316, 0.0737975333333333, 0.0674917222222222, 0.09966528,         0.0610297368421053, 0.0595655789473684, 0.057491,           0.0831318230769231, 0.06051375,         0.0669281066666667, 0.0751655882352941, 0.134414210526316,  0.065350725}

},

{
{0.15702438346162,  0.0772661450737638, 0.147116204792851,  0.0721141629365879, 0.133325070172657,  0.0716761140317293, 0.133792608995568,  0.0646439980318757, 0.128212480231754,  0.0650322663459215, 0.127569026811932,  0.0696548601298678, 0.130338602109992,  0.0684294262768662, 0.107318435352718,  0.0671845932107721, 0.117145670662961,  0.0756873873817673, 0.0880749522531512, 0.0575058631559483, 0.0966796135022046, 0.0619657046028087, 0.153270404904261,  0.0641443844744502, 0.0934056663251269, 0.0687849631807948, 0.218243138940152,  0.0652418579721341, 0.277404232155238,  0.077263693048115,  0.158024878719184,  0.0698218006750551, 0.123852550924508,  0.0617272467849319, 0.109376948861674,  0.0587500562023666, 0.161429171875,     0.064203021130702,  0.0993196986132985, 0.0893690391451608, 0.0914017271663616, 0.063768172052693,  0.0999840212923069, 0.0640846005334275, 0.108631871457251,  0.069461444590409,  0.144112054339858,  0.0656822348611576, 0.249745667834536,  0.120330414474174}, 

{0.107361862230611, 0.220227222222222,  0.179655466686556,  0.1982045,          0.0971114391444913, 0.0597744777178464, 0.0931059829931103, 0.0667904880622848, 0.0848523078374867, 0.0685401394763978, 0.0711400061324861, 0.0777120957745849, 0.0868335228890588, 0.0576856083917777, 0.0748795297342236, 0.0702511067803757, 0.0788866361169687, 0.062006207213905,  0.0741349369740656, 0.053187192549739,  0.0690164346038037, 0.0665009617226919, 0.0627170325146097, 0.0656569937530267, 0.0664789585997564, 0.0717308325068239, 0.108287458776323,  0.0670236278637781, 0.0777052988920565, 0.0717736532737169, 0.0791971498745804, 0.062609380155024,  0.102828534947178,  0.0697239365188954, 0.0659012050523473, 0.0789436018606219, 0.0725982544371509, 0.0846205585408808, 0.0697375756023635, 0.0800410130104769, 0.374386277777778,  0.108122272522333,  0.0654578902099224, 0.09910225,         0.109307372189095,  0.107045360506963,  0.139659019240195,  0.10614859472593,   0.133902990389396,  0.687108933333333}, 

{0.135039449656479, 0.100052840208526,  0.0924431653639045, 0.113945561311114,  0.0918050099053471, 0.0795706866965205, 0.07902949926545,   0.0875900859535039, 0.103347848925016,  0.0754803692604038, 0.102183413304503,  0.0825377995505192, 0.0885053996779784, 0.0812311263202444, 0.0859713699575361, 0.0721641006265807, 0.0930142905584785, 0.0798652337684091, 0.091563521539105,  0.0934171807533002, 0.0957768920737534, 0.0902539055980589, 0.0831570219447939, 0.0729091186717695, 0.0871615432009171, 0.0943471410209699, 0.0857834063895538, 0.119926502251807,  0.082782300743632,  0.0947823332986424, 0.0847295881582703, 0.0881916526581719, 0.0831475477889422, 0.0824846855329145, 0.0841825314698902, 0.105752786132795,  0.0989674153141937, 0.0785643842142747, 0.0861895551063764, 0.123280243321836,  0.0856283800900195, 0.080976661493423,  0.098310417815094,  0.081169397706362,  0.107807167006032,  0.10041499675088,   0.10341459090438,   0.086812860531212,  0.0897547218795363, 0.092070945185561}, 

{0.12235570151838,  0.152481585150464,  0.153939852395194,  0.0977809339981673, 0.115832822645309,  0.0850775229761509, 0.0900033652712078, 0.0788039735022763, 0.118666202463052,  0.0864246360046303, 0.0838546496770283, 0.0777162849768292, 0.104279807798422,  0.0715729906158897, 0.111302049793419,  0.107210309916967,  0.0869572929790951, 0.0805622237743941, 0.084977030112521,  0.0811308352046327, 0.108551812721707,  0.0839653118181103, 0.0970963700603524, 0.0937640384068496, 0.0879235480837289, 0.131410728809223,  0.0862585793087336, 0.0912702335964634, 0.0862611750875991, 0.0916918303964341, 0.100071854457626,  0.0792236228764453, 0.0914352872846631, 0.0974379822122496, 0.0849856418688947, 0.0896055896974579, 0.0986495318825738, 0.0780776104600457, 0.0855012699258436, 0.0875689300716745, 0.0875406507681186, 0.0839783405269727, 0.0996879612964616, 0.0908069479469892, 0.0968399217767123, 0.0757516485488726, 0.106579740753408,  0.0820669067943394, 0.113678442925726,  0.168745308265599}, 

{0.141027979232582, 1.36617708483085,   0.153388220259863,  0.161557104765715,  0.125831616487327,  0.0710718159969664, 0.0866435065868264, 0.0711766377449901, 0.0848318463534908, 0.0766509922134495, 0.0866424099119902, 0.0730790686278856, 0.085548673390016,  0.0939167042533502, 0.0932014978815342, 0.066866800730088,  0.0719588987690405, 0.0798500809248555, 0.0801365113030046, 0.0959182033108638, 0.0898878713400622, 0.0689979581305725, 0.0812152108809555, 0.0717185920332656, 0.0793564800035572, 0.0784209178503441, 0.0821272576792662, 0.0706809660398661, 0.0852299477753556, 0.0843248115198521, 0.0707635065035511, 0.0755021452446478, 0.094559757758963,  0.0877548956044937, 0.0914661059547993, 0.0837739091792933, 0.07204491855678,   0.0831134634767791, 0.0851362571199027, 0.0847254259420038, 0.077855191710613,  0.0797785337032573, 0.0759241180050929, 0.0725996341690972, 0.0898959735273165, 0.140352,           0.103882135529409,  0.105264,           0.0863399662922006, 0.192401615919023}, 

{0.169704948435535, 0.323731237632285,  0.1362439952847,    0.403150251084562,  0.142089987046547,  0.0716190886471458, 0.0921399206936528, 0.0767488918578932, 0.0818506691884911, 0.0748363186844684, 0.0823386748077075, 0.0690455516499231, 0.0956343671544982, 0.111140047094983,  0.0984753930724303, 0.0715460263877701, 0.0947662753821562, 0.0789542646288295, 0.0953387925013249, 0.0759150288576775, 0.110963296674416,  0.0796460438643956, 0.115261382652136,  0.0865084944324983, 0.0997145343168997, 0.0777386839723867, 0.0949126902878533, 0.0646736867778173, 0.0933357680297841, 0.0752051770576345, 0.0822740661121365, 0.0716073137571517, 0.0904924010641999, 0.0672047749976556, 0.0823969684488493, 0.0756294721305324, 0.14750418195816,   0.0671884696280019, 0.126777691422619,  0.0770077251629159, 0.0907865372202555, 0.0696564937264761, 0.104496835563936,  0.0794930003783579, 0.0948787582690402, 0.168553930528185,  0.0917750688664532, 0.0744159413620262, 0.143758422297442,  0.190015950968298}, 

{0.296569653907808, 0.133625233622768,  0.210450942357728,  0.103114055063931,  0.153617553396809,  0.0910980035916336, 0.110189286617019,  0.0711961356996571, 0.0901308612041747, 0.0686046787587589, 0.193438819275644,  0.0814116342289187, 0.104600453217789,  0.0761245872220302, 0.0921190076077936, 0.0729562085945697, 0.0897022963341326, 0.081886214110968,  0.0736672747010765, 0.0996792989704902, 0.0861563420821983, 0.125916445709013,  0.102910180098822,  0.0727290442788019, 0.139025502286359,  0.0748353736827437, 0.0912606579630848, 0.079634294562515,  0.0841867205012346, 0.064976322359073,  0.0855397315956145, 0.0687827576068593, 0.0848031093984968, 0.0824579689768515, 0.0944930034584624, 0.0846003650933048, 0.0925501192579084, 0.0752851789850169, 0.179776211662353,  0.0640128078017171, 0.216641065309571,  0.0621936685755297, 0.0803564193906443, 0.075042175905493,  0.102921150975199,  0.0783504188733007, 0.123310424481737,  0.159221421316752,  0.127020349225525,  0.196440664681996}, 

{0.09249097573551,  0.114176210500327,  0.106214752121241,  0.108863732429109,  0.100852260747919,  0.0858778987928402, 0.0757642767296754, 0.096951950745463,  0.0996966621409282, 0.0965656584249189, 0.0954632855680279, 0.0702196002104127, 0.427491126921702,  0.0818864222824178, 0.0877633638641174, 0.0755302667684963, 0.0987835312296743, 0.0833403725427498, 0.0771233443065198, 0.15426791998024,   0.0756002393637955, 0.0746409913023754, 0.0709129085027406, 0.0874854768599113, 0.0775849859738218, 0.0671799221573384, 0.150199842684997,  0.0774713984078482, 0.0824434429885565, 0.0813744504856889, 0.0781839654033069, 0.119709014625212,  0.0731211532113251, 0.0856716976306714, 0.0837099799091175, 0.088090296200723,  0.0903731809763866, 0.0877679848090124, 0.0835071826931598, 0.0983875768950278, 0.0865029976725062, 0.0933145931633169, 0.108181977046672,  0.0955383597453737, 0.0738347821062739, 0.101196818829019,  0.133920938367091,  0.0951791141146061, 0.102725343425241,  0.13983117597753},  

{0.13200917418,     0.184711907664487,  0.239574865411078,  0.201894028790538,  0.123040444015362,  0.197510572797965,  0.0978928778859972, 0.143649534819469,  0.117822986903009,  0.131156374925018,  0.143407882622511,  0.111611876909244,  0.11361797977581,   0.125454238495849,  0.0974140296601512, 0.0977890607067704, 0.124324270470909,  0.0847766236278659, 0.103371385622846,  0.103713533835695,  0.111619269717295,  0.183860514274479,  0.0998740255541849, 0.115001856515902,  0.0778749166566,    0.0825105613549686, 0.105029400866691,  0.0900625753591425, 0.0983886217553503, 0.109162301634238,  0.0986176237716527, 0.120556712916453,  0.111624761389409,  0.115611627394278,  0.0917013417219646, 0.119826665585176,  0.102012115792422,  0.0964423081411335, 0.135520625577126,  0.116721991487632,  0.0983788198233885, 0.102876550389477,  0.106934600764618,  0.0913067450841481, 0.137808303858932,  0.143378238065048,  0.142986753902526,  0.193689246033495,  0.109271200695462,  0.186516303248121}, 

{0.1193264454545,   0.177875789473684,  0.169456153846154,  0.177982787484325,  0.203359428571429,  0.118323404255319,  0.221408947368421,  0.1249875787841116, 0.113678048780488,  0.099552,           0.126627659574468,  0.106756595744681,  0.186842666666667,  0.161047548478471,  0.262641212121212,  0.625994871794872,  0.170838333333333,  0.122024761904762,  0.213741176470588,  0.0893847619047619, 5.97654054054054,   0.162511245454847,  0.137491875,        0.145681379310345,  0.10563625,         0.0897763636363636, 0.154363244598989,  0.108967619047619,  0.206848292682927,  0.126915714285714,  0.15513124541511,   0.3755835,          0.1197656,          0.197761621621622,  0.1199736,          0.1112184,          0.152482857142857,  0.106231666666667,  0.112343333333333,  0.104114166666667,  0.251268947368421,  0.222833333333333,  0.192131459459459,  0.130475,           0.229954054054054,  0.320441,           0.805848780487805,  0.216293157894737,  0.204602121241525,  0.1500884847847541}

}

};





double factordecrease[50]=  {1.11879,1.11309,1.10743,1.10179,1.09619,1.09061,1.08506,1.07954,1.07404,1.06858,1.06314,1.05773,1.05234,1.04699,1.04166,1.03636,1.03109,1.02584,1.02062,1.01542,1.01026,1.00512,1,0.994911,0.989848,0.984811,0.979799,.974813,0.969852,.964916,0.960006,0.95512,0.95026,0.945424,0.940612,0.935826,0.931063,0.926325,0.921611,0.916921,0.912254,0.907612,0.902993,0.898398,0.893826,0.889277,0.884751,0.880249,0.875769,0.871312};

//double factorincrease[50]={0.871312,0.875769,0.880249,0.884751,0.889277,0.893826,0.898398,0.902993,0.907612,0.912254,0.916921,0.921611,0.926325,0.931063,0.935826,0.940612,0.945424,0.95026,0.95512,0.960006,0.964916,0.969852,0.974813,0.979799,0.984811,0.989848,.994911,1,1.00512,1.01026,1.01542,1.02062,1.02584,1.03109,1.03636,1.04166,1.04699,1.05234,1.05773,1.06314,1.06858,1.07404,1.07954,1.08506,1.09061,1.09619,1.10179,1.10743,1.11309,1.11879};

double factorincrease[50]={0.893825,0.898397,0.902993,0.907611,0.912254,0.91692,0.921611,0.926324,0.931063,0.935825,0.940612,0.945423,0.950259,0.95512,0.960006,0.964915,0.969852,0.974813,0.979798,0.98481,0.989847,0.994911,1,1.005115,1.010256,1.015423,1.020617,1.025838,1.03109,1.036363,1.041656,1.046991,1.052345,1.057731,1.063137,1.068574,1.074042,1.07953,1.085059,1.090609,1.09619,1.101791,1.107433,1.113096,1.118789,1.124513,1.130258,1.136044,1.14185,1.147697};


    int oddposition=$odd;
    int evenposition=$even;

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

    double f1=0.974813;

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
     scaledcal[l][m][n] = factorhan[l][m][n]*truncatedsinglecal[l][m][n] ;
     scaledcal[l][m][n] = factorzhangmodified[l][m][n]*truncatedsinglecal[l][m][n] ;
   }
   }
   }
*/


//the new one


   for(int l=0;l <1; l++)
   {
    for(int m=0;m <10; m++)
   {

    for(int n=0; n <50; n++)
    {

    if(n%2 == 0)
    {
      scaledcal[l][m][n] = (factorzhangmodified[l][m][n]/factorincrease[oddposition])*truncatedsinglecal[l][m][n]/f1;
    }else
    {
      scaledcal[l][m][n] = (factorzhangmodified[l][m][n]/factordecrease[oddposition])*truncatedsinglecal[l][m][n];
    }

    }
    }
    }




   for(int l=1;l <2; l++)
   {
    for(int m=0;m <10; m++)
   {
   for(int n=0; n <50; n++)
   {

    if(n%2 == 0)
     {
      scaledcal[l][m][n] = (factorzhangmodified[l][m][n]/factordecrease[evenposition])*truncatedsinglecal[l][m][n];
     }else
     {
      scaledcal[l][m][n] = (factorzhangmodified[l][m][n]/factorincrease[evenposition])*truncatedsinglecal[l][m][n]/f1;
    }


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
     fivesumcal[l][m][n] =  scaledcal[l][m][n-1]  +  scaledcal[l][m][n] + scaledcal[l][m][n+1];
    }

   for(int n=48;n <49; n++)
    {
     fivesumcal[l][m][n] =   scaledcal[l][m][n-1] +  scaledcal[l][m][n] + scaledcal[l][m][n+1];
    }


   for(int n=49;n <50; n++)
    {
      fivesumcal[l][m][n] = scaledcal[l][m][n-2]  +  scaledcal[l][m][n-1]  +  scaledcal[l][m][n];
    }


    for(int n=2;n <48; n++)
     {
      fivesumcal[l][m][n] =scaledcal[l][m][n-2]+ scaledcal[l][m][n-1] + scaledcal[l][m][n] + scaledcal[l][m][n+1] + scaledcal[l][m][n+2];
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




