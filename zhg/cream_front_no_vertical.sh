  user=zhanghg
  filenumber=49
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_front_no_vertical
  odd=22
  cut=8000


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


    int evenposition=$ijob;
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

{
{0.095035328,   0.063987761,    0.108291073,    0.166758503,    0.100430002,    0.083262534,    0.08590433, 0.070786818,    0.08761232, 0.075036777,    0.084092243,    0.076535174,    0.098378651,    0.075622053,    0.07862903, 0.083275039,    0.079763352,    0.084688413,    0.087718278,    0.103185646,    0.098174695,    0.084299677,    0.093541278,    0.101747304,    0.086940557,    0.080919451,    0.094618933,    0.115679888,    0.108506394,    0.085771025,    0.093449236,    0.071848093,    0.096467855,    0.067010755,    0.096703927,    0.118694415,    0.093301635,    0.082172358,    0.08406099, 0.092248166,    0.099092649,    0.059351921,    0.085422371,    0.078476829,    0.133724892,    0.089426343,    0.08606131, 0.055219048,    0.087153461,    0.167448883},


{0.110142223,   0.160426758,    0.148333308,    0.061564792,    0.079320365,    0.074928952,    0.064844357,    0.067719459,    0.11723593,     0.063790133,    0.067580808,    0.061507186,    0.07406802,     0.063774976,    0.068607634,    0.062538083,    0.137866942,    0.068693717,    0.059956412,    0.066371374,    0.075515686,    0.061109653,    0.095382645,    0.12957068,     0.133078896,    0.063475545,    0.070110829,    0.137810904,    0.063810774,    0.139707227,    0.069359736,    0.062594798,    0.067216251,    0.109150956,    0.130282561,    0.063309196,    0.06378087,     0.094924224,    0.066272596,    0.078067229,    0.058810883,    0.065931425,    0.063144232,    0.067264327,    0.061556948,    0.173113546,    0.09379597,     0.166049189,    0.069699057,    0.073692248},


{0.093723649,   0.115910399,    0.069080108,    0.284701313,    0.065510392,    0.130344229,    0.046198375,    0.128008918,    0.062145383,    0.172316864,    0.065928002,    0.119345253,    0.067741746,    0.129727349,    0.061178505,    0.150854146,    0.061246853,    0.119807653,    0.059967639,    0.114169011,    0.059922123,    0.187803875,    0.059811116,    0.157128981,    0.06028489,     0.130728967,    0.060570721,    0.132018544,    0.061888948,    0.121904085,    0.060662769,    0.142455337,    0.056193112,    0.182832681,    0.07133843,     0.145774432,    0.305370212,    0.137965282,    0.064810881,    0.13361938,     0.064002238,    0.129574223,    0.058924171,    0.123675133,    0.062029332,    0.155037662,    0.085506015,    0.169950163,    0.068746477,    0.179028074},

{0.088564162,   0.135386002,    0.140641732,    0.10085154,     0.130854239,    0.075925275,    0.087552479,    0.088805359,    0.09560439,     0.080715844,    0.087810958,    0.080017303,    0.088459603,    0.075881787,    0.074226365,    0.075487947,    0.085480573,    0.076853199,    0.083561076,    0.076214675,    0.080546573,    0.089412534,    0.079342684,    0.080515948,    0.078745316,    0.078515128,    0.081306341,    0.096835584,    0.125780064,    0.076053508,    0.074499393,    0.080412185,    0.082899265,    0.087966864,    0.082516248,    0.075127903,    0.099961362,    0.104470286,    0.075519129,    0.080242306,    0.082233057,    0.084655563,    0.100767419,    0.066698893,    0.112759274,    0.088546861,    0.137418196,    0.131693771,    0.082140322,    0.085689177},



{0.260118795,   0.13540915,     0.1672545,      0.160661213,    0.131668667,    0.117402215,    0.10864726,     0.219765452,    0.120380644,    0.11247706,     0.137147647,    0.128600464,    0.129058711,    0.128330569,    0.094957578,    0.121550503,    0.112670622,    0.121433585,    0.127745595,    0.13800306,     0.105882388,    0.119382796,    0.109926674,    0.22578717,     0.10958699,     0.127262226,    0.124398403,    0.223999711,    0.111441659,    0.122922306,    0.105280347,    0.215238752,    0.117815305,    0.135667807,    0.136858471,    0.144146489,    0.114251846,    0.137544799,    0.098363965,    0.153910746,    0.098906172,    0.123217938,    0.10805128,     0.129539312,    0.104291192,    0.226743751,    0.208858114,    0.215664502,    0.289195114,    0.139882994},


{0.304953087,   0.304953087,    0.304953087,    0.155132422,    0.158999577,    0.070214364,    0.136756659,    0.066824956,    0.128258276,    0.067820457,    0.121765067,    0.071088543,    0.121001009,    0.063435173,    0.116748632,    0.076365011,    0.106211994,    0.07560986,     0.126948277,    0.068098382,    0.127547875,    0.073944817,    0.288337648,    0.074574376,    0.126781593,    0.071616282,    0.126309732,    0.074994695,    0.111946842,    0.085914815,    0.127417886,    0.081516309,    0.134701174,    0.074706692,    0.128012664,    0.08728964,     0.122984319,    0.066513131,    0.209372951,    0.082935114,    0.290758953,    0.081122983,    0.132976207,    0.092556256,    0.328141655,    0.285375977,    0.120202309,    0.183188309,    0.152815878,    0.136239293},



{0.109737544,   0.053466406,    0.171251914,    0.096211993,    0.098610374,    0.043481987,    0.084815479,    0.041056592,    0.079544844,    0.041795458,    0.075517803,    0.043586443,    0.07504394,     0.039233952,    0.072406647,    0.046673263,    0.065871901,    0.046591576,    0.078732392,    0.041819382,    0.079104259,    0.050272567,    0.158991595,    0.045523477,    0.078629016,    0.044338562,    0.078336371,    0.047468723,    0.069428612,    0.052360195,    0.07902364,     0.050059002,    0.083540682,    0.046202968,    0.079392517,    0.054136396,    0.076273974,    0.041022474,    0.129851572,    0.052632792,    0.161020095,    0.049685654,    0.08247087,     0.057402713,    0.182732038,    0.14246294,     0.074548592,    0.113612048,    0.094775289,    0.084494612},


{0.112878429,   0.094395451,    0.094096116,    0.239771604,    0.088736431,    0.075422153,    0.083070093,    0.069856396,    0.082208575,    0.076281245,    0.082876471,    0.110082025,    0.082235529,    0.069945112,    0.073545337,    0.079740679,    0.146803025,    0.079798961,    0.075827343,    0.075827343,    0.080902099,    0.103114158,    0.080346657,    0.089731274,    0.078128677,    0.091665432,    0.071709478,    0.108731642,    0.074026686,    0.083208816,    0.071204393,    0.085265919,    0.145679594,    0.094338597,    0.088159632,    0.081042338,    0.077718597,    0.089376312,    0.099087633,    0.087136717,    0.104136428,    0.078805557,    0.128997418,    0.090798176,    0.11870655,     0.095823105,    0.108042692,    0.150007072,    0.14040691,     0.102077507},


{0.016912475,   0.008848702,    0.063447242,    0.024103072,    0.078698238,    0.007270188,    0.008291948,    0.00795362,     0.011142678,    0.008134646,    0.008380732,    0.017315888,    0.006911055,    0.006660022,    0.007335009,    0.006808388,    0.007864148,    0.006673772,    0.010190737,    0.010190737,    0.006701956,    0.007868637,    0.008602212,    0.011018426,    0.009962317,    0.012194093,    0.007397149,    0.005965897,    0.006565707,    0.007459488,    0.007319282,    0.008181747,    0.012457766,    0.010531723,    0.007200654,    0.007946382,    0.006864601,    0.006370581,    0.008614723,    0.007741751,    0.009631716,    0.006033183,    0.006367268,    0.006700358,    0.007518216,    0.007937805,    0.006668959,    0.008339339,    0.02266114,     0.006313797}
},


{


{0.134430284,   0.07173657, 0.139194612,    0.067108343,    0.123372441,    0.065983061,    0.129140228,    0.060344073,    0.123592213,    0.060930109,    0.122640767,    0.064883165,    0.121373254,    0.064920548,    0.104503852,    0.062524327,    0.11002491, 0.065295928,    0.090815552,    0.055564014,    0.092766852,    0.056444533,    0.150818471,    0.065752742,    0.094122632,    0.065960647,    0.193818976,    0.06439047, 0.250771218,    0.080603281,    0.159705152,    0.065152625,    0.116421186,    0.057348614,    0.105301178,    0.055128562,    0.17649258, 0.17649258, 0.094816657,    0.085340417,    0.088871682,    0.061754946,    0.097233,   0.063023749,    0.104656531,    0.063448698,    0.140408754,    0.062296359,    0.226879382,    0.129629847},


{0.109949468,   1.811313639,    0.168584008,    2.643206555,    0.106631236,    0.060184432,    0.102258372,    0.066212985,    0.092088376,    0.068341762,    0.070791982,    0.078313093,    0.093140672,    0.057354834,    0.073551999,    0.069544241,    0.075552599,    0.06162745, 0.073535455,    0.055240447,    0.06649853, 0.067467341,    0.062923229,    0.06768708, 0.067708991,    0.072718318,    0.109828106,    0.069149677,    0.073763414,    0.070865612,    0.08237794, 0.06139259, 0.105740044,    0.07019016, 0.066639774,    0.084519627,    0.072829127,    0.072829127,    0.071654351,    0.079737285,    0.079737285,    0.079737285,    0.066485234,    0.079737285,    0.112394371,    0.103468883,    0.143357285,    0.112416455,    0.138880936,    0.138880936},


{0.138463905,   0.112029517,    0.094605208,    0.286227568,    0.100280857,    0.085563679,    0.087517033,    0.091618754,    0.105289116,    0.081953777,    0.101430789,    0.086852547,    0.092710968,    0.083722361,    0.091255688,    0.077574916,    0.093052179,    0.08477039, 0.091601544,    0.089623842,    0.100301675,    0.09369266, 0.084667361,    0.079350106,    0.092414395,    0.100102069,    0.094885936,    0.119102681,    0.087749906,    0.098845356,    0.075843978,    0.091855091,    0.087472408,    0.086215573,    0.082955639,    0.102291916,    0.101823001,    0.080818136,    0.092967749,    0.121088584,    0.088734423,    0.094414237,    0.099889234,    0.08693771, 0.10812254, 0.100823584,    0.104017483,    0.091466477,    0.09651758, 0.098880989},



{0.131095502,   0.13901193, 0.153469431,    0.09756432, 0.111610959,    0.08672047, 0.08900757, 0.079876342,    0.109537025,    0.084928485,    0.086691112,    0.07694513, 0.102599514,    0.070710877,    0.105678001,    0.099922334,    0.089250656,    0.082547155,    0.083330844,    0.080785228,    0.102888483,    0.086554649,    0.090803115,    0.0946178,  0.087223347,    0.138550831,    0.085712091,    0.091018753,    0.088775616,    0.094587577,    0.091325015,    0.077879155,    0.092233821,    0.094953228,    0.078973324,    0.089702107,    0.098451895,    0.078373607,    0.084870013,    0.085954489,    0.087243876,    0.087037587,    0.093563448,    0.091895945,    0.092403933,    0.074488656,    0.092314297,    0.082577247,    0.107422382,    0.170460283},


{0.140073149,   2.341260226,    0.138794827,    0.134486733,    0.127707684,    0.067549362,    0.076954285,    0.066362796,    0.079645668,    0.070306458,    0.077034635,    0.070431641,    0.080775123,    0.080661757,    0.081755164,    0.066564016,    0.06750877, 0.072681584,    0.076198616,    0.089244904,    0.080513457,    0.068282709,    0.076168306,    0.064743815,    0.078767068,    0.072761046,    0.078410231,    0.06491151, 0.077876245,    0.079647776,    0.158125734,    0.069623241,    0.089954369,    0.082516772,    0.085170299,    0.079330708,    0.069879276,    0.080907916,    0.081371434,    0.079768124,    0.076144351,    0.07122494, 0.071548404,    0.068302747,    0.085508788,    2.787735412,    0.095134399,    2.43349546, 0.083818371,    0.234006377},


{0.202610719,   0.370226439,    0.147833905,    0.498007943,    0.154973823,    0.08066138, 0.101319815,    0.08757865, 0.092744544,    0.082173126,    0.090551698,    0.0792781,  0.105048947,    0.124681707,    0.107025714,    0.081663157,    0.104221526,    0.091260115,    0.105596748,    0.085334193,    0.113981967,    0.088795757,    0.136593208,    0.099447055,    0.116202206,    0.090304322,    0.102282515,    0.073351203,    0.100463415,    0.084657811,    0.094173485,    0.080115555,    0.094690181,    0.079146467,    0.089131739,    0.086597662,    0.164977294,    0.076782414,    0.140664082,    0.087090387,    0.100639462,    0.079532617,    0.110172026,    0.107103497,    0.105934131,    0.183873723,    0.103424252,    0.080543267,    0.157828905,    0.148906101},


{0.28212156,    0.118457806,    0.13936691, 0.080835089,    0.12581187, 0.073887909,    0.091248304,    0.058703397,    0.070891611,    0.055417071,    0.1488674,  0.068136654,    0.083707923,    0.060544508,    0.073024513,    0.059221258,    0.069103903,    0.066411996,    0.062742576,    0.078749135,    0.069622762,    0.094697836,    0.081896225,    0.060190554,    0.112895627,    0.061357653,    0.077562215,    0.06476811, 0.071464661,    0.054603169,    0.074786059,    0.056591926,    0.068885372,    0.068848223,    0.075499069,    0.069139591,    0.070773599,    0.060051373,    0.139559886,    0.054829381,    0.187176654,    0.048670931,    0.064212799,    0.089513828,    0.081864716,    0.061861791,    0.095294255,    0.126905889,    0.112478166,    0.163044251},



{0.048349103,   0.054290219,    0.056618406,    0.052548333,    0.051624205,    0.045031779,    0.037213096,    0.045692373,    0.048349219,    0.046130927,    0.049359098,    0.037107593,    0.182871539,    0.041234161,    0.045231893,    0.039031276,    0.047350989,    0.043468775,    0.040896033,    0.074178699,    0.039745269,    0.037312357,    0.035819672,    0.042247208,    0.038267238,    0.034912758,    0.076689637,    0.040251501,    0.044171869,    0.041568318,    0.039655366,    0.061137753,    0.03824123, 0.041976577,    0.045824177,    0.044232686,    0.043362474,    0.043763905,    0.040522196,    0.050635352,    0.041677546,    0.045538459,    0.055928754,    0.057435773,    0.037829427,    0.061282089,    0.063235931,    0.05115369, 0.054649759,    0.062048306},


{0.089638146,   0.17460696, 0.149529263,    0.154741281,    0.062824553,    0.144972941,    0.050120797,    0.104327834,    0.057509616,    0.065214143,    0.067348769,    0.065180652,    0.058519304,    0.068437436,    0.056380647,    0.05263359, 0.055069792,    0.05307882, 0.054871114,    0.058417448,    0.071408846,    0.137786216,    0.062389908,    0.068410696,    0,  0.04993746, 0.059734508,    0.051770425,    0.049557874,    0.053407116,    0.052753865,    0.059807397,    0.053197732,    0.065840514,    0.048908083,    0.059607958,    0.054351908,    0.05407715, 0.064681089,    0.06338312, 0.051497262,    0.056675507,    0.051217849,    0.089638146,    0.17460696, 0.149529263,    0.154741281,    0.062824553,    0.144972941,    0.050120797},

{0.003893217,   0.004429092,    0.004334086,    0.003297294,    0.003998997,    0.00286018, 0.002909862,    0.002442216,    0.002670065,    0.002619737,    0.002653877,    0.002587371,    0.002453893,    0.002466626,    0.002379482,    0.003074444,    0.0028227,  0.003552611,    0.00234507, 0.002389953,    0.002556385,    0.002448261,    0.002456225,    0.004453953,    0.029083563,    0.002715392,    0.006005379,    0.002980441,    0.002496482,    0.0035555,  0.005078537,    0.003125704,    0.002900329,    0.003247286,    0.003120333,    0.00315365, 0.003275792,    0.003112517,    0.00253347, 0.002666245,    0.002514885,    0.003627216,    0.002412305,    0.003893217,    0.004429092,    0.004334086,    0.003297294,    0.003998997,    0.00286018, 0.002909862}

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


  int oddposition0=$odd ;
  int oddposition1=$odd ;
  int oddposition2=$odd ;
  int oddposition3=$odd ;
  int oddposition4=$odd ;
  int oddposition5=$odd ;
  int oddposition6=$odd ;
  int oddposition7=$odd ;
  int oddposition8=$odd ;
  int oddposition9=$odd ;

  int evenposition0=$ijob;
  int evenposition1=$ijob;
  int evenposition2=$ijob;
  int evenposition3=$ijob;
  int evenposition4=$ijob;
  int evenposition5=$ijob;
  int evenposition6=$ijob;
  int evenposition7=$ijob;
  int evenposition8=$ijob;
  int evenposition9=$ijob;



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




