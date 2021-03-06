  user=zhanghg
  filenumber=49
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_front_no_horizon_new
  odd=22
  even=22    
  cut=7000
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


    int evenposition=$neweven;
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




double factordecrease[50]={1,0.994911,0.989848,0.98481,0.979799,0.974812,0.969852,0.964916,0.960005,0.95512,0.950259,0.945423,0.940612,0.935825,0.931063,0.926325,0.92161,0.91692,0.912254,0.907612,0.902993,0.898397,0.893825,0.889277,0.884751,0.880249,0.875769,0.871312,0.866878,0.862466,0.858077,0.85371,0.849366,0.845043,0.840743,0.836464,0.832208,0.827972,0.823759,0.819567,0.815396,0.811246,0.807118,0.80301,0.798924,0.794858,0.790813,0.786788,0.782784,0.778801};

double factorincrease[50]={0.778801,0.782784,0.786788,0.790813,0.794858,0.798924,0.80301,0.807118,0.811246,0.815396,0.819567,0.823759,0.827972,0.832208,0.836464,0.840743,0.845043,0.849366,0.85371,0.858077,0.862466,0.866878,0.871312,0.875769,0.880249,0.884751,0.889277,0.893825,0.898397,0.902993,0.907612,0.912254,0.91692,0.92161,0.926325,0.931063,0.935825,0.940612,0.945423,0.950259,0.95512,0.960005,0.964916,0.969852,0.974812,0.979799,0.98481,0.989848,0.994911,1};

/*
double horizoncorrector1[50]={0.98455364495969,0.927914667829626,0.927914667829626,0.927914667829626,0.927914667829626,0.918253582924242,0.944513732184096,0.980397803632454,0.984160591176406,0.992930555555556,1.02111328214269,1.03102402948956,1.00634003654248,0.992136846078692,0.978701325725425,0.994377927872793,1.01090786712595,1.04761611685541,1.07616925832819,1.12797056493984,1.1147303260412,1.04276000081681,1,1.00975418217976,1.04393245563824,1.04817828604941,1.01789731469089,0.991509392093555,1.00773587512087,1.01137408575834,1.00103897122246,1.01104797354822,1.02424396981037,1.02623177670979,0.988657358749405,0.977726902225942,0.979511251411222,0.956396219953338,0.966577883536363,0.965319729838481,0.937960839469113,0.95281442169545,0.960355819682922,0.929855366526195,0.870457224121641,0.910089645567751,0.946046088169362,0.961368300167555,0.984361144921709,1.03270400277348};



double horizoncorrector2[50]={1.04745143749605,1.00537349955359,1.00537349955359,1.00537349955359,1.00537349955359,1.0067911949026,1.01899787733214,1.03569735456344,1.02128552953493,1.01462245261191,1.02761394554949,1.034156103313,1.01829538889215,1.01696134152086,1.00777287944579,1.01912881221473,1.01797717069523,1.02628136788008,1.02597256514232,1.05179675675676,1.04414197322405,1.01161504271419,1,1.01014178565199,1.03322770022854,1.03480433728242,1.02005200324321,1.00481418034999,1.02296069288636,1.02502711176791,1.01336555287059,1.01929395199142,1.02611972831208,1.03444638821865,1.01428396681716,1.01487928833107,1.03015860018466,1.01149444407479,1.02429615820859,1.02806856382844,1.00550649866058,1.02239023460706,1.04576710856324,1.03268958060307,0.979034227368478,1.01511365849587,1.02045428482724,1.01340777467606,1.00919177138684,1.0474815104047};


double verticalcorrector1[50]={1.16850250922603,1.08075427664369,0.989290486630947,1.0395476760117,1.09952441489093,1.03344039681249,1.03832327991177,1.08836920529801,1.04979934790939,1.08032556184683,1.09466035677372,1.11589876418553,1.04415724900955,1.04041286062202,1.02290241879411,1.03555488158181,1.08518117067779,1.12169858271655,1.02872811159377,0.924238139294357,0.801257050991298,0.92993945158871,1,1.13297575978189,1.19387371684141,1.21315843899645,1.14273832805089,1.09553318088762,1.14297526854859,1.13766634839172,1.11204740504529,1.09785172512255,1.10448521424261,1.10469588648167,1.07725034905103,1.05582914109014,1.06932213372223,1.04394997615631,1.1212367758742,1.09880880904921,1.09411849106235,1.01630186097549,1.05295219596616,1.05109443775672,1.0876370145507,0.991079841698599,1.00750010459629,0.95874046305396,1.12116259238204,1.1313396815663};




double verticalcorrector2[50]={1.04049884376208,1.00659107558743,0.964405139035551,1.00208559653939,1.03298930204062,0.985532784077284,0.994993677247819,1.02936940643967,0.992066468382258,1.0099060081091,1.01006113483457,1.02844943539053,0.991673201713187,1.00413609858574,0.994772193863217,0.997897105593482,1.01625840352368,1.04210540614579,1.01438387560273,1.00128342059868,0.946682900644354,1.02869766547922,1,1.02262532908257,1.02796022144853,1.02675639744459,0.995932311939746,0.980402555910543,1.0192197405335,1.01176623159672,1.00219468702849,1.00081100003044,1.00781424473978,1.012242375729,1.00358001731141,0.996861924686192,1.01230025554974,0.986276097912167,1.032982347476,1.00725408329394,1.01837188464474,0.977114290566358,1.01232919794235,1.00610263886673,1.04091532000923,0.986669324656283,1.01393921638166,0.956288603250516,1.05241990799594,1.02279802417124};


double total[50]={0.785511583454853,0.83991537737015,0.859325443456651,0.928342917992126,0.910047973839758,0.907083871375523,0.974824345259658,0.968765695186501,0.967207577678786,0.903115159331663,1.00298708122719,0.968774604959754,1.0190051273894,0.987005351702298,1.00247865238956,0.965889476242415,1.00547938070481,0.968405779237027,0.969130974056428,0.996093179272555,1.05190159086832,0.965889326666728,1.00005219355267,1.0030619749843,1.07600612796635,0.954979134928158,1.08835081809991,0.922909809033771,1.02686073997783,1.03296481783956,1.00043531857074,0.950705626210138,1.03620841598171,1.02472528109059,1.01264244262539,0.993075697787364,1.04869391569208,0.894367670951599,0.994608386875833,1.04804809047018,0.98203464277324,0.947459467687419,0.9696076604625,1.02435782507542,0.871066434261867,0.98907207932741,0.985713458732849,0.949411666599692,0.888861619103577,1.03041801938497};

*/




double horizoncorrector[50]={1.08008034881624,0.917312932688377,0.921540855540382,1.00567630532178,0.969783583754418,0.909326887624296,0.958677669652331,1.03537153977857,1.01146315988965,1.00702459796289,1.06103003785452,1.08152167955953,1.02086953284071,1.01589017396266,0.98434420392757,1.02901958152737,1.03310178441893,1.09050081105542,1.10710913009795,1.21592049764563,1.18078648489307,1.05203307605724,1.00050840048349,1.01254582612855,1.09853782175699,1.09820217178237,1.04836981841616,0.992000837739482,1.04622320631992,1.04583988127818,1.01341722379221,1.04465695646055,1.05732938396727,1.07912588533339,0.997111586961699,0.983443779393079,1.03915004938047,0.97402426628586,0.997566697701958,1.00559332840056,0.925978567259029,0.982173753719715,1.03197777722818,0.993155423837292,0.808634751644462,0.936946971132743,0.984042540214749,0.98796878713568,0.96060863834781,1.11746379520019};

double verticalcorrector[50]={1.28852879293568,1.10535772612802,0.90299061120490,1.06030673255397,1.20776388776702,0.97434005839373,1.03596105531475,1.18173121440039,1.02349615912129,1.13328038123003,1.11860475162473,1.18478697525669,1.01716755695521,1.07531252261987,1.02973266327685,1.04061443981816,1.11701915489546,1.22092635755802,1.06048012638593,0.96340651140710,0.70843321809850,1.06778321843171,1.00005648748349,1.17432364500546,1.24417710345249,1.28179492221744,1.15254404112364,1.0481125393701,1.23751698117155,1.1432478691607,1.12840292473323,1.13098715291074,1.12972796992006,1.13138482401037,1.09290654821411,1.04738392869906,1.14214555092697,1.01007576575316,1.24626598531389,1.0709347755576,1.17492273750407,0.963372180038777,1.11659476990295,1.06118064784499,1.19786134206963,0.970208178019002,1.09052563191152,0.834310479072963,1.3229097198429,1.11183256495982};


double total[50]={0.83899512667233,0.895213364397723,0.906450380503794,0.958544840259395,0.942940501124441,0.925013227850017,0.97091541044891,0.984526113699134,0.961728517781182,0.961553053039563,0.977369973036982,0.999347723800285,0.999981081620558,1.00871691138495,0.997269020450737,0.980319215073921,0.99152860688999,0.993497797191858,0.976243924610962,1.00280512659715,0.990006058524501,1.00590340440611,1.00004171861808,1.01869627375908,1.03790640410572,1.01687166189332,1.01775082889629,0.981837143583516,1.01200029736177,1.01604986149039,1.00519929069963,0.985064676692701,1.01327508145193,1.01889961722409,1.01096677649936,1.00763289714588,1.01171960030991,0.960367009666097,1.00866795417036,1.01343546153853,1.00699224846589,0.970010718357696,0.982274637517586,0.986237746330021,0.956813319054361,0.968724257611042,0.97940509703459,0.942156293498136,0.932082163483612,0.922683586569212};



double corrector[2][10]=
{
{
0.737153,1.141692,0.927483,0.880052,0.788305,0.933883,1.142468,1.045752,1.082438,0.794631
},
{
1.005564,1.114255,0.902073,0.868974,0.95253,1.041639,1.982235,1.244247,0.992191,1.865165
}
};




    int oddposition=$odd;
    int evenposition=$even;
    int newoddposition=$ijob;
    int newevenposition=$neweven;



    TString fileribbon= Form(zhangname);

 
    TFile fin(fileribbon + "-truncated.root","READ");
    TFile fout(fileribbon + "-scaled.root","recreate");


    TTree * truncatedtree = (TTree *)fin.Get("truncatedtree"); 
    TTree * scaledtree = new TTree ("scaledtree", "scaledtree");


   UInt_t  truncatedtrig;
   double  truncatedsinglecal[2][10][50];

   double s=0.95;

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




   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = 0.95*corrector[l][m]*total[n]*horizoncorrector[n]*factorzhangmodified[l][m][n]*truncatedsinglecal[l][m][n] ;
   }
   }
   }


   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = 0.95*corrector[l][m]*total[n]*verticalcorrector[n]*factorzhangmodified[l][m][n]*truncatedsinglecal[l][m][n] ;
   }
   }
   }




/*



    for(int l=0;l <1; l++)
    {
    for(int m=0;m <10; m++)
    {
    for(int n=0; n <50; n++)
    {
      if(n%2 == 0)
      {
      scaledcal[l][m][n] = s*corrector[l][m]*total[n]*horizoncorrector[n]*(factorzhangmodified[l][m][n]*factorincrease[oddposition]/factorincrease[newoddposition])*truncatedsinglecal[l][m][n];
      }else
      {
      scaledcal[l][m][n] = s*corrector[l][m]*total[n]*horizoncorrector[n]*(factorzhangmodified[l][m][n]*factordecrease[oddposition]/factordecrease[newoddposition])*truncatedsinglecal[l][m][n];
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
      scaledcal[l][m][n] = s*corrector[l][m]*total[n]*verticalcorrector[n]*(factorzhangmodified[l][m][n]*factorincrease[evenposition]/factorincrease[newevenposition])*truncatedsinglecal[l][m][n];
     }else
     {
      scaledcal[l][m][n] = s*corrector[l][m]*total[n]*verticalcorrector[n]*(factorzhangmodified[l][m][n]*factordecrease[evenposition]/factordecrease[newevenposition])*truncatedsinglecal[l][m][n];
      }

    }
    }
    }


*/




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
   double  finaloddall[50];
   double  finalevenall[50];
   double  finalall;
   double  finalevenall1;
   double  finaloddall1;

  fivetree->SetBranchAddress("fivetrig", &fivetrig);
  fivetree->SetBranchAddress("fivesinglecal", &fivesinglecal);
  fivetree->SetBranchAddress("fivesumcal", &fivesumcal);


  finaltree->Branch("finaltrig",&finaltrig,"finaltrig/i");
  finaltree->Branch("finalsinglecal",&finalsinglecal,"finalsinglecal[2][10][50]/D");
  finaltree->Branch("finalsumcal",&finalsumcal,"finalsumcal[2][10][50]/D");
  finaltree->Branch("finalevenall",&finalevenall,"finalevenall[50]/D");
  finaltree->Branch("finaloddall",&finaloddall,"finaloddall[50]/D");
  finaltree->Branch("finalall",&finalall,"finalall/D");








    int newoddposition=$ijob;
    int newevenposition=$neweven;


  int encal = fivetree->GetEntries();

  for (long i=0; i< encal; ++i)
 {


   fivetree->GetEntry(i);

   for(int n=0; n <50; n++)
   {
    finaltrig=fivetrig;
    finaloddall1=0;
    finalevenall1=0;
    finalall=0;

   for(int l=0;l <1; l++)
   {

   for(int m=0;m <10; m++)
   {
    finalsumcal[l][m][n] = fivesumcal[l][m][n] ;
    finaloddall1  = finaloddall1 + fivesumcal[l][m][n];
   }
   }

    finaloddall[n]= finaloddall1;


   for(int l=1;l <2; l++)
   {

   for(int m=0;m <10; m++)
   {
    finalsumcal[l][m][n] = fivesumcal[l][m][n] ;
    finalevenall1  = finalevenall1 + fivesumcal[l][m][n];
   }
   }

    finalevenall[n]= finalevenall1;

}
    finalall = finaloddall[newoddposition] + finalevenall[newevenposition];
//    finalall = finaloddall[newoddposition];



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




