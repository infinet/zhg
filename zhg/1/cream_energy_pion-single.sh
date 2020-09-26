  user=zhanghg
  filenumber=17
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_energy_pion
  even=8
  odd=8
  cut=15





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
  if(sumcal[0][0][oddposition] +sumcal[1][0][evenposition]>energycut)
//  if(sumcal[0][0][oddposition] +sumcal[1][0][evenposition] + sumcal[0][1][oddposition]> energycut)
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



/*

double factor1[2][10][50]=
{
{

{0.0182337,  0.0103166,  0.0137193,  0.0187744,  0.0116976,  0.0115788,  0.0108747,  0.00959895, 0.011777,   0.014199,   0.0110309,  0.0102701,  0.0140578,  0.0162858,  0.00972933, 0.0103907,  0.0110374,  0.0114022,  0.0112752,  0.0116799,  0.0129104,  0.010751,   0.0115843,  0.0166795,  0.0110901,  0.0104463,  0.0114812,  0.0217863,  0.012223,   0.0203952,  0.0114564,  0.0116992,  0.0105394,  0.0127667,  0.0130795,  0.0144294,  0.0108567,  0.0188097,  0.0102514,  0.013221,   0.0121509,  0.0101038,  0.011222,   0.0110524,  0.0117893,  0.0108456,  0.0101808,  0.0114673,  0.0100613,  0.0133437},

{0.0493277,  0.0723995,  0.0722362,  0.0289776,  0.0390359,  0.0375178,  0.0332146,  0.034346,   0.0575095,  0.0324532,  0.0350574,  0.0315469,  0.0368549,  0.0333498,  0.0349035,  0.0326733,  0.0692356,  0.0347729,  0.030641,   0.034836,   0.0382607,  0.03176,    0.0471388,  0.0498166,  0.0628658,  0.0323828,  0.0353004,  0.0785089,  0.0341831,  0.0739442,  0.0350818,  0.0330389,  0.032922,   0.0581221,  0.0631126,  0.034645,   0.0323058,  0.039461,   0.0342079,  0.0385078,  0.0310759,  0.0339969,  0.0335319,  0.0363791,  0.0293245,  0.0890442,  0.037811,   0.0883388,  0.03332,    0.0483642},


{0.0785813,  0.114523,   0.0660597,  0.26077,    0.0627302,  0.130416,   0.107589,   0.128112,   0.0597417,  0.169965,   0.0627405,  0.121825,   0.067413,   0.133348,   0.0585408,  0.159707,   0.0587333,  0.117948,   0.0576728,  0.112177,   0.0591311,  0.185063,   0.0579905,  0.151786,   0.0578904,  0.130347,   0.0577508,  0.135062,   0.0568568,  0.132151,   0.0559872,  0.151811,   0.0546691,  0.181328,   0.0589846,  0.141383,   0.0682246,  0.141223,   0.0605889,  0.134442,   0.0579933,  0.11913,    0.0558728,  0.129583,   0.0551397,  0.158865,   0.0599356,  0.181206,   0.0745815,  0.157183},


{0.0797809,  0.129974,   0.13461,    0.098392,   0.130396,   0.0724571,  0.0859208,  0.0845799,  0.0930212,  0.078347,   0.0854153,  0.0784608,  0.085447,   0.0745862,  0.0727235,  0.0740683,  0.0846315,  0.0749409,  0.0829061,  0.0746529,  0.0787261,  0.0832338,  0.0787766,  0.0797543,  0.0769866,  0.0799744,  0.080333,   0.089564,   0.120691,   0.0753664,  0.0745094,  0.0819775,  0.0865942,  0.0845433,  0.0826279,  0.0738512,  0.0909118,  0.108267,   0.0726057,  0.0811353,  0.07922,    0.0823139,  0.0976883,  0.0688341,  0.102626,   0.0881192,  0.12543,    0.132058,   0.0813436,  0.0818857},

{0.106574,   0.13492,    0.270638,   0.127892,   0.3575, 0.0779247,  0.078548,   0.118297,   0.0782161,  0.0823383,  0.0759303,  0.0790927,  0.105716,   0.101052,   0.0792338,  0.0972989,  0.0700392,  0.0867429,  0.0854629,  0.0929273,  0.0945519,  0.0998399,  0.0800203,  0.117809,   0.0943807,  0.115905,   0.0948944,  0.104436,   0.0700629,  0.0896105,  0.0830297,  0.0891803,  0.0782732,  0.114491,   0.0835835,  0.0952866,  0.0821967,  0.0829346,  0.0874798,  0.0855665,  0.0668265,  0.0817672,  0.0898827,  0.0930485,  0.0947913,  0.116688,   0.205204,   0.137861,   0.0744372,  0.463025},


{0.0824983,  0.0795321,  0.111258,   0.107809,   0.0795365,  0.0738308,  0.0682897,  0.135779,   0.0754541,  0.0719604,  0.0861997,  0.081744,   0.0830627,  0.0794777,  0.0605713,  0.0778988,  0.0703574,  0.0750913,  0.0846905,  0.0759281,  0.0664246,  0.0705754,  0.0712236,  0.142444,   0.0688629,  0.0831416,  0.0809323,  0.141633,   0.0628206,  0.0743108,  0.0662848,  0.131539,   0.0762613,  0.0845061,  0.0760291,  0.0805625,  0.0728227,  0.0831825,  0.0597601,  0.100598,   0.0635364,  0.0738876,  0.0666171,  0.0763554,  0.0663751,  0.0812157,  0.124932,   0.12632,    0.12607,    0.0928711},


{0.10311,    0.0471988,  0.0640379,  0.0591375,  0.0471291,  0.0437416,  0.0393374,  0.0795238,  0.0434785,  0.0418844,  0.0494354,  0.0475371,  0.0473714,  0.0471578,  0.0352912,  0.0451514,  0.0419508,  0.0440539,  0.0485668,  0.0463706,  0.0388427,  0.0419376,  0.0418164,  0.0840972,  0.0414599,  0.0472553,  0.0470663,  0.0833356,  0.0378264,  0.0442162,  0.0391905,  0.0766312,  0.0440556,  0.0497036,  0.044749,   0.0476857,  0.0419632,  0.0492221,  0.0353351,  0.0563941,  0.0379273,  0.0458236,  0.0392802,  0.0457629,  0.0388244,  0.048802,   0.072434,   0.0733207,  0.0731745,  0.0513298},

{0.0342057,  0.0182214,  0.0578263,  0.02873,    0.0329692,  0.0141881,  0.0290343,  0.0135036,  0.0268187,  0.0136069,  0.0250372,  0.0145871,  0.0252779,  0.0127379,  0.024253,   0.0153634,  0.022046,   0.0148162,  0.0274481,  0.0138389,  0.026276,   0.0151256,  0.0659457,  0.0150636,  0.0258566,  0.0142537,  0.0259532,  0.0153513,  0.0233001,  0.0158565,  0.0267838,  0.0162349,  0.0270337,  0.0151121,  0.0258504,  0.0164705,  0.0251352,  0.0132805,  0.0423243,  0.0159107,  0.0517093,  0.0157278,  0.0263405,  0.0166404,  0.0548277,  0.047502,   0.0240022,  0.0343526,  0.0303757,  0.0257619},

{0.0139643,  0.0103099,  0.0159934,  0.0281175,  0.0108618,  0.008288,   0.009772,   0.0074808,  0.00971231, 0.008466,   0.00897692, 0.0134187,  0.00894077, 0.00745537, 0.00850123, 0.00869008, 0.0189828,  0.00864854, 0.007865,   0.00888754, 0.0111319,  0.0116886,  0.00835262, 0.0113312,  0.00810408, 0.0108915,  0.00847562, 0.012801,   0.00840085, 0.0106517,  0.00874531, 0.00916477, 0.0146732,  0.00913485, 0.008396,   0.00911615, 0.00893615, 0.0105954,  0.00945308, 0.00996808, 0.0135536,  0.00878062, 0.0155378,  0.0104648,  0.0125223,  0.0107862,  0.0111379,  0.0107862,  0.0111379,  0.0116045},

{0.00721405, 0.0075427,  0.0063279,  0.0062029,  0.0064119,  0.0057531,  0.00761785, 0.0061135,  0.00689,    0.00609495, 0.00664885, 0.00708083, 0.00603955, 0.00597515, 0.0074963,  0.0053546,  0.0072094,  0.0066623,  0.00704815, 0.00609495, 0.00999345, 0.00698165, 0.00758,    0.00769605, 0.0141123,  0.00645169, 0.00833465, 0.0058406,  0.0058288,  0.0085651,  0.00697275, 0.014424,   0.00878535, 0.0079285,  0.0068828,  0.00780605, 0.0066018,  0.00866965, 0.00681845, 0.00633635, 0.0120893,  0.0058882,  0.00586265, 0.00626955, 0.00846845, 0.00647529, 0.0083653,  0.00634586, 0.0083653,  0.00648115}


},
{


{0.0419878,  0.0182787,  0.03897,    0.022701,   0.0348152,  0.0180752,  0.035149,   0.0170214,  0.0355073,  0.0169911,  0.0352755,  0.0180466,  0.0361095,  0.0179405,  0.0296473,  0.0174647,  0.0327703,  0.0193418,  0.0257842,  0.0154578,  0.0269835,  0.0164005,  0.042598,   0.016936,   0.025671,   0.0184759,  0.0801572,  0.0167491,  0.101042,   0.0201017,  0.0386615,  0.0182267,  0.0342338,  0.0167677,  0.0288982,  0.0157522,  0.0394688,  0.0165805,  0.0268445,  0.0247864,  0.027275,   0.0165614,  0.0275813,  0.0168809,  0.0300137,  0.0167728,  0.0371862,  0.0172686,  0.0825967,  0.0471603},

{0.0803973,  1.76367,    0.154925,   2.93559,    0.0688959,  0.0476581,  0.0695094,  0.0513247,  0.0647597,  0.0527093,  0.0564715,  0.0582099,  0.0650874,  0.044898,   0.0583489,  0.0545216,  0.0628888,  0.049634,   0.0587713,  0.0434981,  0.0547647,  0.0524383,  0.0499836,  0.0526291,  0.0515251,  0.0545064,  0.0867706,  0.0520152,  0.0588239,  0.055342,   0.0614745,  0.0470794,  0.0850316,  0.0538625,  0.0533324,  0.0578206,  0.053182,   0.0611846,  0.0522204,  0.0593664,  0.425283,   1.34702,    0.0511308,  1.83847,    0.0876737,  0.0732828,  0.105206,   0.0761928,  0.100227,   0.601096},


{0.120916,   0.0988882,  0.0896167,  0.222795,   0.097751,   0.0834997,  0.0847897,  0.0895146,  0.103147,   0.0791291,  0.100247,   0.0847776,  0.0908449,  0.0822729,  0.0900567,  0.0757427,  0.0906282,  0.0830296,  0.0901599,  0.088837,   0.095941,   0.0909338,  0.0869296,  0.0766288,  0.090415,   0.0940578,  0.0897365,  0.112437,   0.0861673,  0.0945428,  0.0876167,  0.0899866,  0.0849126,  0.085722,   0.0804938,  0.103903,   0.0981082,  0.0791363,  0.0912165,  0.114243,   0.0893777,  0.0856254,  0.0999207,  0.0863015,  0.106011,   0.10194,    0.0985953,  0.085528,   0.0921694,  0.0941792},


{0.112543,   0.122695,   0.135653,   0.0986038,  0.107895,   0.0830673,  0.0848417,  0.0768915,  0.109628,   0.0814557,  0.0834021,  0.0739413,  0.0987779,  0.0680048,  0.104031,   0.0956437,  0.0860484,  0.0790899,  0.0802836,  0.0788484,  0.103938,   0.0821516,  0.0900321,  0.0889881,  0.0827374,  0.120245,   0.0818988,  0.0852723,  0.0867926,  0.0878376,  0.0951032,  0.0760635,  0.0884333,  0.0905793,  0.0769078,  0.087285,   0.0929056,  0.0754666,  0.0795862,  0.082341,   0.0837993,  0.0832901,  0.0847457,  0.0849184,  0.0868685,  0.0720688,  0.0942281,  0.078381,   0.107476,   0.142885},

{0.127055,   2.6854, 0.133801,   0.125952,   0.12068,    0.0658465,  0.0772215,  0.065317,   0.0769209,  0.0681783,  0.0764039,  0.0685233,  0.0752404,  0.0793924,  0.08004,    0.0647712,  0.0661438,  0.0711925,  0.0748059,  0.0868567,  0.0807949,  0.0655422,  0.0753991,  0.0635271,  0.0748846,  0.0725712,  0.0765312,  0.0649484,  0.0769262,  0.0808342,  0.0672421,  0.0682839,  0.0835255,  0.081411,   0.0810075,  0.0754105,  0.0671006,  0.0741704,  0.0778699,  0.0776729,  0.0720269,  0.0724522,  0.0692083,  0.0700757,  0.0802079,  6.34189,    0.0995876,  2.71398,    0.0790566,  0.319871},


{0.101598,   0.168862,   0.0667983,  0.223789,   0.0688105,  0.0380247,  0.0505819,  0.0417506,  0.0463258,  0.0390331,  0.0452001,  0.0376661,  0.0512556,  0.0582036,  0.0521911,  0.0386581,  0.0512292,  0.042026,   0.052616,   0.0404085,  0.0584781,  0.042262,   0.0632308,  0.0447788,  0.0541717,  0.0414149,  0.0503571,  0.0341056,  0.0513307,  0.0399389,  0.0467878,  0.0367721,  0.0483, 0.0367367,  0.0463431,  0.040571,   0.0770295,  0.0363235,  0.0661132,  0.0417894,  0.048966,   0.0372288,  0.0556361,  0.0428385,  0.0515173,  0.0891157,  0.0510351,  0.0378878,  0.0745792,  0.0664174},

{0.018614,   0.0384215,  0.045999,   0.0261475,  0.0420845,  0.0244807,  0.0304889,  0.019659,   0.0236875,  0.0184639,  0.0487863,  0.022836,   0.0283555,  0.0202147,  0.0242976,  0.0197432,  0.023233,   0.0219215,  0.0206458,  0.0258248,  0.0237573,  0.0348202,  0.027134,   0.0194757,  0.0384313,  0.0203314,  0.0243524,  0.021366,   0.0228664,  0.0182507,  0.0237273,  0.0190567,  0.0227991,  0.0229442,  0.0254138,  0.0234596,  0.0235227,  0.0203486,  0.0477635,  0.0181644,  0.0599322,  0.0186732,  0.0212888,  0.020516,   0.0266785,  0.0206912,  0.0340104,  0.0411533,  0.0354814,  0.0532824},

{0.0174017,  0.018577,   0.0207016,  0.0184178,  0.018455,   0.0166175,  0.0135612,  0.0168835,  0.0177013,  0.0170867,  0.0181421,  0.0135955,  0.0662602,  0.0149984,  0.0167083,  0.0143159,  0.0174069,  0.015293,   0.0156041,  0.0275916,  0.0150079,  0.0137909,  0.0134797,  0.01552,    0.013997,   0.0123926,  0.0274991,  0.0146745,  0.0154337,  0.015236,   0.0146606,  0.0223687,  0.0135543,  0.0156978,  0.0169314,  0.0157949,  0.0168222,  0.0162564,  0.0151963,  0.0182247,  0.0154091,  0.0176861,  0.0195887,  0.0177997,  0.0137069,  0.0187712,  0.0229691,  0.0169982,  0.0186903,  0.0251278},


{0.00935224, 0.013408,   0.00684145, 0.0100106,  0.00935224, 0.013408,   0.00684145, 0.0100106,  0.00757238, 0.00802968, 0.00877256, 0.00774973, 0.00740835, 0.00792734, 0.00714619, 0.00671001, 0.00751471, 0.00657726, 0.00721578, 0.00796865, 0.00864824, 0.0106626,  0.00786242, 0.00631194, 0.00631194, 0.0072251,  0.00763882, 0.0072035,  0.0072251,  0.00763882, 0.0072251,  0.00763882, 0.0072035,  0.00828928, 0.0066677,  0.00791961, 0.00725326, 0.0072979,  0.00870296, 0.00760818, 0.00698448, 0.00706354, 0.00677224, 0.00926384, 0.0112848,  0.0101954,  0.0101183,  0.0126549,  0.0067547,  0.00968952},


{0.0244077,  0.0115332,  0.0135666,  0.00935156, 0.0244077,  0.0115332,  0.0135666,  0.00935156, 0.0113452,  0.0103324,  0.013898,   0.0105154,  0.0126273,  0.0098565,  0.0115028,  0.0116, 0.0155067,  0.0137519,  0.0125713,  0.00975867, 0.0124237,  0.00963417, 0.0121397,  0.0115152,  0.0115152,  0.0220843,  0.0121711,  0.0135733,  0.0220843,  0.0121711,  0.0220843,  0.0121711,  0.0135733,  0.0116616,  0.0132181,  0.0112789,  0.0145877,  0.0127954,  0.0133272,  0.0101597,  0.0124343,  0.0121809,  0.0117603,  0.0126048,  0.0159439,  0.0133005,  0.0136467,  0.0168207,  0.0120427,  0.100917}

}
};

*/






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

}
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





double factorrefined[2][10][50]=
{
{
{0.883737,  0.888716,   0.893723,   0.898758,   0.903821,   0.908913,   0.914034,   0.919183,   0.924362,   0.929569,   0.934806,   0.940073,   0.945369,   0.950695,   0.956051,   0.961437,   0.966854,   0.972301,   0.977779,   0.983287,   0.988827,   0.994398,   1,  1.00563,    1.0113, 1.017,  1.02273,    1.02849,    1.03428,    1.04011,    1.04597,    1.05186,    1.05779,    1.06375,    1.06974,    1.07577,    1.08183,    1.08792,    1.09405,    1.10022,    1.10641,    1.11265,    1.11892,    1.12522,    1.13156,    1.13793,    1.14434,    1.15079,    1.15727,    1.16379},

{
0.962967,   0.96462,    0.966276,   0.967935,   0.969597,   0.971262,   0.972929,   0.974599,   0.976272,   0.977948,   0.979627,   0.981309,   0.982994,   0.984681,   0.986372,   0.988065,   0.989761,   0.99146,    0.993162,   0.994867,   0.996575,   0.998286,   1,  1.00172,    1.00344,    1.00516,    1.00688,    1.00861,    1.01034,    1.01208,    1.01382,    1.01556,    1.0173, 1.01905,    1.0208, 1.02255,    1.0243, 1.02606,    1.02782,    1.02959,    1.03136,    1.03313,    1.0349, 1.03668,    1.03846,    1.04024,    1.04203,    1.04381,    1.04561,    1.0474},

{
0.945014,   0.947447,   0.949885,   0.95233,    0.954782,   0.957239,   0.959703,   0.962174,   0.96465,    0.967133,   0.969623,   0.972118,   0.974621,   0.977129,   0.979644,   0.982166,   0.984694,   0.987229,   0.98977,    0.992318,   0.994872,   0.997433,   1,  1.00257,    1.00515,    1.00774,    1.01034,    1.01294,    1.01554,    1.01816,    1.02078,    1.02341,    1.02604,    1.02868,    1.03133,    1.03398,    1.03665,    1.03931,    1.04199,    1.04467,    1.04736,    1.05006,    1.05276,    1.05547,    1.05819,    1.06091,    1.06364,    1.06638,    1.06912,    1.07187
},

{
0.904837,   0.90896,    0.913101,   0.917261,   0.921439,   0.925637,   0.929854,   0.934091,   0.938346,   0.942621,   0.946915,   0.951229,   0.955563,   0.959916,   0.96429,    0.968683,   0.973096,   0.977529,   0.981982,   0.986456,   0.99095,    0.995465,   1,  1.00456,    1.00913,    1.01373,    1.01835,    1.02299,    1.02765,    1.03233,    1.03703,    1.04176,    1.0465, 1.05127,    1.05606,    1.06087,    1.0657, 1.07056,    1.07544,    1.08034,    1.08526,    1.0902, 1.09517,    1.10016,    1.10517,    1.11021,    1.11526,    1.12034,    1.12545,    1.13058},

{
0.90878,    0.91274,    0.916717,   0.920711,   0.924723,   0.928752,   0.932799,   0.936864,   0.940946,   0.945046,   0.949164,   0.9533, 0.957453,   0.961625,   0.965815,   0.970024,   0.97425,    0.978495,   0.982759,   0.987041,   0.991342,   0.995662,   1,  1.00436,    1.00873,    1.01313,    1.01754,    1.02198,    1.02643,    1.0309, 1.03539,    1.03991,    1.04444,    1.04899,    1.05356,    1.05815,    1.06276,    1.06739,    1.07204,    1.07671,    1.0814, 1.08612,    1.09085,    1.0956, 1.10038,    1.10517,    1.10999,    1.11482,    1.11968,    1.12456},

{
0.910631,   0.914515,   0.918415,   0.922331,   0.926264,   0.930214,   0.934181,   0.938165,   0.942165,   0.946183,   0.950218,   0.95427,    0.958339,   0.962426,   0.96653,    0.970652,   0.974791,   0.978948,   0.983123,   0.987315,   0.991525,   0.995754,   1,  1.00426,    1.00855,    1.01285,    1.01717,    1.0215, 1.02586,    1.03024,    1.03463,    1.03904,    1.04347,    1.04792,    1.05239,    1.05688,    1.06138,    1.06591,    1.07046,    1.07502,    1.07961,    1.08421,    1.08883,    1.09348,    1.09814,    1.10282,    1.10752,    1.11225,    1.11699,    1.12175},

{
0.900539,   0.904837,   0.909156,   0.913496,   0.917856,   0.922238,   0.92664,    0.931063,   0.935507,   0.939972,   0.944459,   0.948967,   0.953497,   0.958048,   0.962621,   0.967216,   0.971833,   0.976472,   0.981133,   0.985816,   0.990521,   0.995249,   1,  1.00477,    1.00957,    1.01439,    1.01923,    1.0241, 1.02898,    1.0339, 1.03883,    1.04379,    1.04877,    1.05378,    1.05881,    1.06386,    1.06894,    1.07404,    1.07917,    1.08432,    1.08949,    1.0947, 1.09992,    1.10517,    1.11045,    1.11575,    1.12107,    1.12642,    1.1318, 1.1372},

{
0.879935,   0.885066,   0.890227,   0.895418,   0.900639,   0.90589,    0.911172,   0.916485,   0.921829,   0.927204,   0.932611,   0.938049,   0.943518,   0.94902,    0.954553,   0.960119,   0.965718,   0.971349,   0.977013,   0.982709,   0.988439,   0.994203,   1,  1.00583,    1.0117, 1.01759,    1.02353,    1.0295, 1.0355, 1.04154,    1.04761,    1.05372,    1.05986,    1.06604,    1.07226,    1.07851,    1.0848, 1.09113,    1.09749,    1.10389,    1.11032,    1.1168, 1.12331,    1.12986,    1.13645,    1.14307,    1.14974,    1.15644,    1.16319,    1.16997},

{
0.922302,   0.925699,   0.929109,   0.932531,   0.935966,   0.939413,   0.942873,   0.946346,   0.949832,   0.95333,    0.956841,   0.960366,   0.963903,   0.967453,   0.971017,   0.974593,   0.978183,   0.981786,   0.985402,   0.989031,   0.992674,   0.99633,    1,  1.00368,    1.00738,    1.01109,    1.01481,    1.01855,    1.0223, 1.02607,    1.02985,    1.03364,    1.03745,    1.04127,    1.04511,    1.04895,    1.05282,    1.0567, 1.06059,    1.06449,    1.06842,    1.07235,    1.0763, 1.08026,    1.08424,    1.08824,    1.09225,    1.09627,    1.10031,    1.10436},

{
0.974058,   0.975223,   0.976388,   0.977556,   0.978724,   0.979894,   0.981066,   0.982238,   0.983413,   0.984588,   0.985765,   0.986944,   0.988124,   0.989305,   0.990488,   0.991672,   0.992857,   0.994044,   0.995232,   0.996422,   0.997613,   0.998806,   1,  1.0012, 1.00239,    1.00359,    1.00479,    1.00599,    1.00719,    1.0084, 1.0096, 1.01081,    1.01202,    1.01323,    1.01444,    1.01565,    1.01687,    1.01808,    1.0193, 1.02052,    1.02174,    1.02296,    1.02418,    1.02541,    1.02663,    1.02786,    1.02909,    1.03032,    1.03155,    1.03278}

},

{

{
1.13561,    1.12906,    1.12255,    1.11608,    1.10965,    1.10326,    1.0969, 1.09058,    1.08429,    1.07804,    1.07183,    1.06565,    1.05951,    1.0534, 1.04733,    1.04129,    1.03529,    1.02932,    1.02339,    1.01749,    1.01163,    1.0058, 1,  0.994236,   0.988506,   0.982808,   0.977144,   0.971512,   0.965912,   0.960345,   0.95481,    0.949307,   0.943835,   0.938395,   0.932987,   0.927609,   0.922263,   0.916947,   0.911662,   0.906408,   0.901184,   0.895989,   0.890825,   0.885691,   0.880586,   0.875511,   0.870464,   0.865447,   0.860459,   0.8555},
{
1.13561,    1.12906,    1.12255,    1.11608,    1.10965,    1.10326,    1.0969, 1.09058,    1.08429,    1.07804,    1.07183,    1.06565,    1.05951,    1.0534, 1.04733,    1.04129,    1.03529,    1.02932,    1.02339,    1.01749,    1.01163,    1.0058, 1,  0.994236,   0.988506,   0.982808,   0.977144,   0.971512,   0.965912,   0.960345,   0.95481,    0.949307,   0.943835,   0.938395,   0.932987,   0.927609,   0.922263,   0.916947,   0.911662,   0.906408,   0.901184,   0.895989,   0.890825,   0.885691,   0.880586,   0.875511,   0.870464,   0.865447,   0.860459,   0.8555},


{
1.12414,    1.11818,    1.11225,    1.10635,    1.10048,    1.09464,    1.08883,    1.08306,    1.07731,    1.0716, 1.06591,    1.06026,    1.05463,    1.04904,    1.04347,    1.03794,    1.03243,    1.02695,    1.0215, 1.01609,    1.0107, 1.00533,    1,  0.994695,   0.989418,   0.984169,   0.978948,   0.973755,   0.968589,   0.963451,   0.958339,   0.953255,   0.948198,   0.943168,   0.938165,   0.933188,   0.928237,   0.923313,   0.918415,   0.913542,   0.908696,   0.903875,   0.89908,    0.894311,   0.889566,   0.884847,   0.880153,   0.875484,   0.870839,   0.866219},
{
1.12556,    1.11952,    1.11352,    1.10755,    1.10161,    1.0957, 1.08983,    1.08399,    1.07817,    1.07239,    1.06664,    1.06092,    1.05523,    1.04958,    1.04395,    1.03835,    1.03278,    1.02725,    1.02174,    1.01626,    1.01081,    1.00539,    1,  0.994638,   0.989305,   0.984,  0.978724,   0.973476,   0.968257,   0.963065,   0.957901,   0.952765,   0.947656,   0.942575,   0.937521,   0.932494,   0.927494,   0.922521,   0.917574,   0.912655,   0.907761,   0.902894,   0.898052,   0.893237,   0.888448,   0.883684,   0.878946,   0.874233,   0.869545,   0.864883},

{
1.16507,    1.157,  1.149,  1.14104,    1.13315,    1.12531,    1.11752,    1.10979,    1.10211,    1.09448,    1.0869, 1.07938,    1.07191,    1.06449,    1.05713,    1.04981,    1.04255,    1.03533,    1.02817,    1.02105,    1.01399,    1.00697,    1,  0.99308,    0.986207,   0.979382,   0.972604,   0.965874,   0.959189,   0.952551,   0.945959,   0.939413,   0.932912,   0.926456,   0.920044,   0.913677,   0.907354,   0.901075,   0.894839,   0.888647,   0.882497,   0.87639,    0.870325,   0.864302,   0.85832,    0.852381,   0.846482,   0.840624,   0.834806,   0.829029},

{
1.16886,    1.1606, 1.1524, 1.14425,    1.13617,    1.12814,    1.12016,    1.11225,    1.10439,    1.09658,    1.08883,    1.08114,    1.0735, 1.06591,    1.05838,    1.0509, 1.04347,    1.0361, 1.02878,    1.0215, 1.01429,    1.00712,    1,  0.992933,   0.985916,   0.978948,   0.97203,    0.96516,    0.958339,   0.951567,   0.944842,   0.938165,   0.931535,   0.924951,   0.918415,   0.911924,   0.905479,   0.89908,    0.892726,   0.886417,   0.880153,   0.873933,   0.867757,   0.861624,   0.855535,   0.849489,   0.843485,   0.837524,   0.831605,   0.825728},
{
1.13903,    1.13231,    1.12563,    1.11899,    1.11239,    1.10583,    1.0993, 1.09282,    1.08637,    1.07996,    1.07359,    1.06725,    1.06096,    1.0547, 1.04848,    1.04229,    1.03614,    1.03003,    1.02395,    1.01791,    1.0119, 1.00593,    1,  0.9941, 0.988235,   0.982405,   0.976609,   0.970848,   0.96512,    0.959426,   0.953766,   0.948139,   0.942545,   0.936984,   0.931456,   0.925961,   0.920498,   0.915068,   0.909669,   0.904302,   0.898967,   0.893663,   0.888391,   0.88315,    0.87794,    0.87276,    0.867611,   0.862492,   0.857404,   0.852346},



{
1.13235,    1.12597,    1.11963,    1.11332,    1.10705,    1.10081,    1.09461,    1.08844,    1.08231,    1.07621,    1.07015,    1.06412,    1.05812,    1.05216,    1.04623,    1.04034,    1.03448,    1.02865,    1.02286,    1.01709,    1.01136,    1.00567,    1,  0.994366,   0.988764,   0.983194,   0.977655,   0.972147,   0.96667,    0.961224,   0.955808,   0.950424,   0.945069,   0.939745,   0.934451,   0.929186,   0.923951,   0.918746,   0.91357,    0.908423,   0.903305,   0.898216,   0.893156,   0.888124,   0.88312,    0.878145,   0.873198,   0.868278,   0.863387,   0.858523},
{
1.14171,    1.13486,    1.12804,    1.12127,    1.11453,    1.10784,    1.10118,    1.09457,    1.088,  1.08146,    1.07497,    1.06851,    1.06209,    1.05571,    1.04937,    1.04307,    1.03681,    1.03058,    1.02439,    1.01824,    1.01212,    1.00604,    1,  0.993994,   0.988024,   0.98209,    0.976192,   0.970329,   0.964501,   0.958708,   0.95295,    0.947227,   0.941538,   0.935883,   0.930262,   0.924675,   0.919121,   0.913601,   0.908114,   0.90266,    0.897238,   0.89185,    0.886493,   0.881169,   0.875877,   0.870616,   0.865387,   0.86019,    0.855023,   0.849888
},


{
1.18595,    1.17679,    1.1677, 1.15869,    1.14974,    1.14086,    1.13205,    1.12331,    1.11464,    1.10603,    1.09749,    1.08901,    1.0806, 1.07226,    1.06398,    1.05576,    1.04761,    1.03952,    1.03149,    1.02353,    1.01562,    1.00778,    1,  0.992278,   0.984616,   0.977013,   0.969468,   0.961982,   0.954553,   0.947182,   0.939868,   0.932611,   0.925409,   0.918263,   0.911172,   0.904136,   0.897155,   0.890227,   0.883352,   0.876531,   0.869763,   0.863046,   0.856382,   0.849769,   0.843207,   0.836696,   0.830235,   0.823824,   0.817462,   0.81115}


}

};




double factorfiteven[50]={1.09199,1.08763,1.08329,1.07896,1.07466,1.07037,1.06609,1.06184,1.0576,1.05338,1.04917,1.04498,1.04081,1.03666,1.03252,1.0284,1.02429,1.0202,1.01613,1.01207,1.00803,1.00401,1,0.996008,0.992032,0.988072,0.984127,0.980199,0.976286,0.972388,0.968507,0.96464,0.960789,0.956954,0.953134,0.949329,0.945539,0.941765,0.938005,0.93426,0.930531,0.926816,0.923116,0.919431,0.915761,0.912105,0.908464,0.904837,0.901225,0.897628};


double factorfitodd[50]={0.915761,0.919431,0.923116,0.926816,0.93053,0.93426,0.938004,0.941764,0.945539,0.949329,0.953133,0.956954,0.96079,0.96464,0.968506,0.972388,0.976285,0.980198,0.984127,0.988072,0.992031,0.996008,1,1.00401,1.00803,1.01207,1.01613,1.0202,1.02429,1.02839,1.03251,1.03666,1.04081,1.04498,1.04917,1.05338,1.0576,1.06184,1.06609,1.07036,1.07466,1.07896,1.08329,1.08763,1.09199,1.09637,1.10076,1.10517,1.1096,1.11405};






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

  for (long i=0; i< encal; ++i)
 {


    truncatedtree->GetEntry(i);
    scaledtrig=truncatedtrig;





//without attenuation


   
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




//with attenuation, but following the exact value

/*

   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
//     scaledcal[l][m][n] = (factor1[l][m][n]/factor2[l][m][oddposition])*truncatedsinglecal[l][m][n] ;
       scaledcal[l][m][n] = (factor1[l][m][n]/factorrefined[l][m][oddposition])*truncatedsinglecal[l][m][n] ;


   }
   }
   }



   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
//     scaledcal[l][m][n] = (factor1[l][m][n]/factor2[l][m][evenposition])*truncatedsinglecal[l][m][n] ;
       scaledcal[l][m][n] = (factor1[l][m][n]/factorrefined[l][m][evenposition])*truncatedsinglecal[l][m][n] ;

   }
   }
   }

*/




// with attenuation, with layer 7 and 8

/*

   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {
 
  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = (factor1[l][m][n]/factorodd[oddposition])*truncatedsinglecal[l][m][n] ;
   }
   }
   }



   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] =(factor1[l][m][n]/factoreven[evenposition])*truncatedsinglecal[l][m][n] ;
   }
   }
   }

*/



//the following is the case for odd layer and even layer after fitting

/*
   for(int l=0;l <1; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = (factor1[l][m][n]/factorfitodd[oddposition])*truncatedsinglecal[l][m][n] ;
   }
   }
   }

   for(int l=1;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {

  for(int n=0; n <50; n++)
   {
     scaledcal[l][m][n] = (factor1[l][m][n]/factorfiteven[evenposition])*truncatedsinglecal[l][m][n] ;
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




