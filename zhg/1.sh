  user=zhanghg
  filenumber=12
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_uniformscan
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



double factor[2][10][50]=
{
{
{0.1021,    0.0468, 0.0701, 0.0945, 0.1115, 0.0583, 0.0675, 0.0516, 0.0634, 0.0582, 0.0629, 0.0661, 0.0795, 0.0579, 0.063,  0.0755, 0.08,   0.0672, 0.0793, 0.0742, 0.0792, 0.0633, 0.0892, 0.0794, 0.0721, 0.0562, 0.0745, 0.0889, 0.0795, 0.0429, 0.0669, 0.0485, 0.0761, 0.0574, 0.097,  0.095,  0.0661, 0.0696, 0.0644, 0.0799, 0.0826, 0.0593, 0.0777, 0.0645, 0.0882, 0.0747, 0.0696, 0.0458, 0.0732, 0.104},
{0.0917,    0.1352, 0.1396, 0.054,  0.0718, 0.0717, 0.0611, 0.0639, 0.1087, 0.0607, 0.0643, 0.0584, 0.0695, 0.0597, 0.0655, 0.0601, 0.1315, 0.0642, 0.0577, 0.0645, 0.0698, 0.0602, 0.0909, 0.1152, 0.1204, 0.0602, 0.0684, 0.1498, 0.0646, 0.1416, 0.0669, 0.0614, 0.061,  0.1088, 0.1213, 0.0635, 0.0594, 0.0917, 0.0634, 0.0735, 0.057,  0.0646, 0.0612, 0.068,  0.057,  0.1649, 0.0748, 0.1846, 0.0644, 0.0794},
{0.0754,    0.1031, 0.0628, 0.2392, 0.0688, 0.0993, 0.077,  0.1097, 0.0674, 0.1401, 0.0705, 0.0999, 0.069,  0.1097, 0.0725, 0.1109, 0.0691, 0.1094, 0.0642, 0.0928, 0.0662, 0.1682, 0.0614, 0.1098, 0.0653, 0.0993, 0.062,  0.1119, 0.0622, 0.1215, 0.0602, 0.1287, 0.0629, 0.158,  0.0639, 0.1089, 0.0819, 0.1215, 0.0703, 0.1164, 0.0623, 0.1058, 0.0655, 0.105,  0.0648, 0.1231, 0.0699, 0.1378, 0.1054, 0.1291},
{0.0716,    0.1149, 0.1124, 0.0936, 0.1099, 0.0665, 0.0731, 0.081,  0.0783, 0.0749, 0.0725, 0.0749, 0.0761, 0.071,  0.0624, 0.0693, 0.0734, 0.0742, 0.0727, 0.0751, 0.0688, 0.0816, 0.0659, 0.074,  0.0661, 0.0774, 0.0689, 0.0872, 0.1038, 0.0731, 0.0615, 0.079,  0.0686, 0.084,  0.0678, 0.0739, 0.0747, 0.0969, 0.0608, 0.0776, 0.0632, 0.0848, 0.079,  0.071,  0.0885, 0.0916, 0.0993, 0.1292, 0.062,  0.0791},
{0.1005,    0.1363, 0.2948, 0.1274, 0.3565, 0.0778, 0.08,   0.1137, 0.08,   0.0828, 0.0795, 0.0792, 0.1015, 0.0998, 0.0838, 0.0973, 0.0737, 0.0869, 0.0904, 0.0937, 0.0913, 0.0988, 0.0818, 0.1163, 0.0909, 0.1165, 0.0915, 0.1061, 0.0734, 0.0895, 0.0841, 0.09,   0.0801, 0.1051, 0.0876, 0.0947, 0.0819, 0.0829, 0.0841, 0.0857, 0.0698, 0.0816, 0.0887, 0.0936, 0.0927, 0.1185, 0.2062, 0.1697, 0.079,  0.4312},
{0.1963,    0.0977, 0.1299, 0.1182, 0.0978, 0.0891, 0.082,  0.1668, 0.0906, 0.0855, 0.1037, 0.0969, 0.0987, 0.0971, 0.0728, 0.093,  0.0864, 0.0911, 0.0998, 0.0958, 0.0798, 0.0858, 0.0863, 0.1742, 0.0864, 0.0969, 0.0968, 0.175,  0.0777, 0.0918, 0.0814, 0.1581, 0.0916, 0.1015, 0.0919, 0.0997, 0.087,  0.1005, 0.0728, 0.1121, 0.0768, 0.0947, 0.0807, 0.0956, 0.08,   0.1015, 0.1493, 0.1551, 0.152,  0.1054},
{0.3199,    0.1549, 0.1146, 0.1481, 0.1593, 0.0709, 0.1377, 0.0675, 0.1292, 0.0684, 0.1226, 0.0716, 0.1223, 0.064,  0.1183, 0.0771, 0.1071, 0.0746, 0.1324, 0.0689, 0.1281, 0.0742, 0.3019, 0.0746, 0.1262, 0.071,  0.1253, 0.0759, 0.1134, 0.0799, 0.1327, 0.0806, 0.1315, 0.0754, 0.1259, 0.086,  0.1226, 0.0667, 0.2124, 0.0814, 0.3111, 0.0788, 0.1297, 0.0883, 0.3094, 0.2742, 0.1183, 0.1902, 0.1547, 0.132},
{0.1765,    0.0878, 0.2821, 0.1448, 0.1557, 0.0692, 0.1346, 0.0654, 0.1263, 0.0665, 0.1199, 0.0692, 0.1195, 0.0624, 0.1156, 0.0743, 0.1047, 0.0725, 0.1295, 0.0669, 0.1252, 0.0765, 0.2688, 0.072,  0.1234, 0.0692, 0.1225, 0.0747, 0.1108, 0.0766, 0.1297, 0.0783, 0.1286, 0.0736, 0.123,  0.0841, 0.1199, 0.0648, 0.2076, 0.0795, 0.2623, 0.0768, 0.1268, 0.0863, 0.2839, 0.2391, 0.1156, 0.1859, 0.1512, 0.129},
{0.1558,    0.0794, 0.0882, 0.1917, 0.0873, 0.0658, 0.0757, 0.059,  0.0765, 0.0674, 0.0716, 0.1015, 0.0713, 0.0596, 0.0641, 0.0687, 0.2272, 0.0682, 0.0651, 0.0651, 0.0786, 0.096,  0.0662, 0.0885, 0.062,  0.0868, 0.0704, 0.1021, 0.0677, 0.0857, 0.069,  0.0725, 0.1298, 0.0717, 0.0732, 0.072,  0.0648, 0.086,  0.077,  0.0812, 0.1118, 0.0698, 0.1666, 0.0823, 0.0959, 0.0868, 0.0816, 0.1348, 0.2755, 0.1206},
{0.1048,    0.088,  0.0786, 0.1222, 0.1048, 0.0629, 0.0846, 0.0733, 0.0759, 0.0688, 0.0733, 0.0733, 0.0647, 0.055,  0.0667, 0.055,  0.0917, 0.0733, 0.11,   0.001, 0.0688, 0.0688, 0.0667, 0.088,  0.0917, 0.1222, 0.11,   0.055,  0.0611, 0.0733, 0.0786, 0.0815, 0.1,    0.11,   0.0579, 0.0579, 0.0647, 0.0579, 0.0733, 0.0611, 0.088,  0.0579, 0.0579, 0.05,   0.0846, 0.055,  0.0733, 0.0647, 0.1158, 0.0688}

},
{
{0.1648,    0.0685, 0.1528, 0.0717, 0.1266, 0.0652, 0.1344, 0.0619, 0.1307, 0.0613, 0.1315, 0.0658, 0.1336, 0.0652, 0.1072, 0.0635, 0.1204, 0.0704, 0.093,  0.056,  0.0981, 0.0595, 0.1536, 0.0607, 0.0934, 0.0672, 0.241,  0.0608, 0.2733, 0.0817, 0.1545, 0.0661, 0.1265, 0.0608, 0.1046, 0.0577, 0.1507, 0.0697, 0.0967, 0.0817, 0.0968, 0.0606, 0.0998, 0.0608, 0.1093, 0.0618, 0.1311, 0.0626, 0.2548, 0.1625},
{0.0988,    0.2202, 0.1425, 0.1982, 0.0925, 0.0563, 0.0921, 0.0614, 0.0884, 0.0617, 0.0655, 0.0682, 0.0889, 0.0533, 0.0694, 0.0648, 0.0731, 0.0585, 0.0697, 0.0515, 0.065,  0.0625, 0.0593, 0.0621, 0.0614, 0.0659, 0.1044, 0.0617, 0.0691, 0.0649, 0.0725, 0.0556, 0.1014, 0.0632, 0.062,  0.0703, 0.0626, 0.0962, 0.062,  0.0696, 0.2202, 0.1321, 0.0604, 0.0991, 0.1046, 0.0898, 0.1262, 0.0988, 0.1202, 0.2643},
{0.1006,    0.0976, 0.0772, 0.1999, 0.0782, 0.0817, 0.0694, 0.0852, 0.0795, 0.0765, 0.0788, 0.083,  0.0718, 0.0793, 0.0728, 0.0722, 0.0738, 0.0807, 0.0755, 0.0857, 0.0837, 0.0923, 0.0707, 0.0742, 0.0911, 0.0944, 0.0753, 0.1168, 0.0742, 0.0964, 0.0743, 0.0891, 0.0665, 0.0884, 0.0623, 0.1085, 0.0821, 0.0806, 0.0793, 0.1315, 0.0743, 0.0878, 0.0814, 0.0865, 0.0849, 0.1018, 0.085,  0.0932, 0.0793, 0.1},
{0.103, 0.1191, 0.1331, 0.0883, 0.0906, 0.0765, 0.0804, 0.0701, 0.0922, 0.0774, 0.0759, 0.0654, 0.0873, 0.0637, 0.0883, 0.0891, 0.0796, 0.074,  0.0725, 0.0725, 0.0927, 0.0762, 0.0858, 0.0827, 0.0861, 0.1144, 0.0765, 0.0769, 0.081,  0.0778, 0.0886, 0.0717, 0.0813, 0.0806, 0.0673, 0.0812, 0.0819, 0.0675, 0.0762, 0.074,  0.0805, 0.0773, 0.0767, 0.076,  0.0837, 0.0661, 0.0883, 0.0727, 0.1001, 0.1427},
{0.1049,    0.1238, 0.1036, 0.123,  0.0933, 0.0623, 0.0619, 0.0632, 0.0622, 0.0654, 0.0606, 0.0666, 0.0623, 0.0788, 0.0631, 0.0622, 0.0584, 0.0701, 0.0617, 0.0847, 0.0676, 0.0636, 0.0635, 0.0583, 0.077,  0.0716, 0.0596, 0.0598, 0.0701, 0.0734, 0.0551, 0.0629, 0.0726, 0.0756, 0.0655, 0.0698, 0.0574, 0.0676, 0.0673, 0.074,  0.0586, 0.0659, 0.0565, 0.0639, 0.0682, 0.0842, 0.1118, 0.0954, 0.0694, 0.1882},
{0.1691,    0.2979, 0.1225, 0.3926, 0.1294, 0.0692, 0.0872, 0.0753, 0.0798, 0.0706, 0.0777, 0.0681, 0.0898, 0.107,  0.0919, 0.0701, 0.0901, 0.077,  0.0914, 0.073,  0.0991, 0.0762, 0.1169, 0.0806, 0.0996, 0.0761, 0.0867, 0.063,  0.0877, 0.0728, 0.0806, 0.067,  0.0827, 0.0669, 0.0777, 0.073,  0.1426, 0.066,  0.1226, 0.0752, 0.0842, 0.0678, 0.0965, 0.0795, 0.0873, 0.1554, 0.0878, 0.0686, 0.1342, 0.1222},
{0.3339,    0.1364, 0.1725, 0.0951, 0.1527, 0.0915, 0.113,  0.0726, 0.0877, 0.0687, 0.1843, 0.0843, 0.1036, 0.0749, 0.0904, 0.0733, 0.086,  0.0811, 0.0769, 0.0962, 0.0862, 0.1217, 0.1006, 0.0722, 0.1399, 0.0753, 0.09,   0.079,  0.0855, 0.0677, 0.0885, 0.0708, 0.0847, 0.0848, 0.0936, 0.0871, 0.0869, 0.0754, 0.1768, 0.067,  0.2206, 0.0628, 0.0791, 0.075,  0.0988, 0.0766, 0.1192, 0.1559, 0.1335, 0.1968},
{0.1012,    0.1055, 0.1183, 0.107,  0.1073, 0.095,  0.0786, 0.0969, 0.1027, 0.0981, 0.1047, 0.0785, 0.382,  0.0868, 0.0966, 0.0827, 0.1007, 0.0893, 0.0896, 0.16,   0.0858, 0.0795, 0.078,  0.0892, 0.0808, 0.0718, 0.1564, 0.0841, 0.089,  0.088,  0.0841, 0.1285, 0.0787, 0.0912, 0.0971, 0.0912, 0.0979, 0.0945, 0.0881, 0.1039, 0.089,  0.1004, 0.1124, 0.1033, 0.0792, 0.1072, 0.1327, 0.1045, 0.1113, 0.1453},
{0.0786,    0.1576, 0.0788, 0.1459, 0.0648, 0.1056, 0.0484, 0.0788, 0.058,  0.067,  0.07,   0.0645, 0.0546, 0.0682, 0.0591, 0.0536, 0.0564, 0.0534, 0.0577, 0.0627, 0.0626, 0.1361, 0.0641, 0.0701, 0.0529, 0.046,  0.0603, 0.0545, 0.0512, 0.0551, 0.0558, 0.061,  0.0564, 0.0671, 0.0501, 0.0623, 0.0543, 0.0517, 0.0688, 0.0618, 0.0518, 0.0596, 0.0502, 0.0822, 0.0915, 0.0884, 0.0837, 0.1021, 0.0613, 0.0917},
{0.0833,    0.08,   0.0714, 0.0556, 0.0455, 0.04,   0.0417, 0.0417, 0.0455, 0.0385, 0.0417, 0.0455, 0.05,   0.0435, 0.0435, 0.0417, 0.0417, 0.0455, 0.05,   0.0455, 0.0417, 0.0455, 0.0417, 0.0667, 0.05,   0.04,   0.0714, 0.0667, 0.04,   0.0435, 0.05,   0.0625, 0.0476, 0.04,   0.0455, 0.04,   0.0526, 0.0417, 0.0476, 0.0417, 0.04,   0.05,   0.0435, 0.0408, 0.0526, 0.05,   0.0625, 0.0588, 0.0588, 0.125}

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
     scaledcal[l][m][n] = factor[l][m][n]*truncatedsinglecal[l][m][n] ;
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




