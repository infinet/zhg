  user=zhanghg
  filenumber=49
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_front_no_horizon
  even=22
  cut=20
  cutsum=55

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
    double energycutsum=$cutsum;
    double energycuttotal=$cutsumtotal;

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

//   if(sumcal[0][0][oddposition] + sumcal[0][1][oddposition] +sumcal[0][2][oddposition] +sumcal[0][3][oddposition] +sumcal[0][4][oddposition] +sumcal[0][5][oddposition] +sumcal[0][6][oddposition] +sumcal[0][7][oddposition] +sumcal[0][8][oddposition] +sumcal[0][9][oddposition] +sumcal[1][0][evenposition] +sumcal[1][1][evenposition] +sumcal[1][2][evenposition] +sumcal[1][3][evenposition] +sumcal[1][4][evenposition] +sumcal[1][5][evenposition] +sumcal[1][6][evenposition] +sumcal[1][7][evenposition] +sumcal[1][8][evenposition] +sumcal[1][9][evenposition]  > energycut)

if(sumsinglecal[0][0][oddposition]> energycut&&sumsinglecal[0][1][oddposition]> energycut&&sumsinglecal[1][0][evenposition]> energycut&&sumsinglecal[1][1][evenposition]>energycut&&sumcal[0][0][oddposition]> energycutsum&&sumcal[0][1][oddposition]> energycutsum&&sumcal[1][0][evenposition]> energycutsum&&sumcal[1][1][evenposition]>energycutsum)

//if(sumsinglecal[0][8][oddposition]> energycut&&sumsinglecal[0][9][oddposition]> energycut&&sumsinglecal[1][8][evenposition]> energycut&& sumsinglecal[1][9][evenposition] > energycut&&sumcal[0][8][oddposition]> energycutsum&&sumcal[0][9][oddposition]> energycutsum&&sumcal[1][8][evenposition]> energycutsum&&sumcal[1][9][evenposition] > energycutsum)

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
     scaledcal[l][m][n] = factorhan[l][m][n]*truncatedsinglecal[l][m][n] ;
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




  int oddposition0=$ijob;
  int oddposition1=$ijob;
  int oddposition2=$ijob;
  int oddposition3=$ijob;
  int oddposition4=$ijob;
  int oddposition5=$ijob;
  int oddposition6=$ijob;
  int oddposition7=$ijob;
  int oddposition8=$ijob;
  int oddposition9=$ijob;

  int evenposition0=$even ;
  int evenposition1=$even ;
  int evenposition2=$even ;
  int evenposition3=$even ;
  int evenposition4=$even ;
  int evenposition5=$even ;
  int evenposition6=$even ;
  int evenposition7=$even ;
  int evenposition8=$even ;
  int evenposition9=$even ;






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
   double  finalall;

  fivetree->SetBranchAddress("fivetrig", &fivetrig);
  fivetree->SetBranchAddress("fivesinglecal", &fivesinglecal);
  fivetree->SetBranchAddress("fivesumcal", &fivesumcal);


  finaltree->Branch("finaltrig",&finaltrig,"finaltrig/i");
  finaltree->Branch("finalsinglecal",&finalsinglecal,"finalsinglecal[2][10][50]/D");
  finaltree->Branch("finalsumcal",&finalsumcal,"finalsumcal[2][10][50]/D");
  finaltree->Branch("finalall",&finalall,"finalall/D");


  int encal = fivetree->GetEntries();

  for (long i=0; i< encal; ++i)
 {

    fivetree->GetEntry(i);

   for(int n=0; n <50; n++)
   {

    finaltrig=fivetrig;


   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

    finalsinglecal[l][m][n] = fivesinglecal[l][m][n] ;
    finalsumcal[l][m][n] = fivesumcal[l][m][n] ;
   }
   }
   }

    finalall= finalsumcal[0][0][oddposition0] + finalsumcal[0][1][oddposition1] +finalsumcal[0][2][oddposition2] +finalsumcal[0][3][oddposition3] +finalsumcal[0][4][oddposition4] +finalsumcal[0][5][oddposition5] +finalsumcal[0][6][oddposition6] +finalsumcal[0][7][oddposition7] +finalsumcal[0][8][oddposition8] +finalsumcal[0][9][oddposition9] +finalsumcal[1][0][evenposition0] +finalsumcal[1][1][evenposition1] +finalsumcal[1][2][evenposition2] +finalsumcal[1][3][evenposition3] +finalsumcal[1][4][evenposition4] +finalsumcal[1][5][evenposition5] +finalsumcal[1][6][evenposition6] +finalsumcal[1][7][evenposition7] +finalsumcal[1][8][evenposition8] +finalsumcal[1][9][evenposition9];

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




