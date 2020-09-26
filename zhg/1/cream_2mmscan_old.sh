  user=zhanghg
  filenumber=10
  MCDirectory=home/zhanghg/cream
  AnaDirectory=cream_2mmscan


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
# create subtract .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_$ijob.sh





#------------------------------------------------
# create cut .sh
#------------------------------------------------


cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_cut_$ijob.sh <<-EOA
#!/bin/bash

ulimit -d unlimited
ulimit -n 4096

cd /store/bl2/scratch/$user/${AnaDirectory}/code
root -b /store/bl2/scratch/$user/${AnaDirectory}/code/cut_$ijob.C 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_cut_$ijob.sh










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
# create  condor executable subtract
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_$ijob
  echo now subtract job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_subtract.sh



#------------------------------------------------
# create  condor executable cut
#------------------------------------------------
  cat >> /store/bl2/scratch/$user/${AnaDirectory}/submit_cut.sh <<-EOA
  condor_submit /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_cut_$ijob
  echo now cut job_${ijob} start running 

EOA
chmod a+x /store/bl2/scratch/$user/${AnaDirectory}/submit_cut.sh





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
# create subtract executable jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_subtract_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_subtract_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_subtract_$ijob.err
Queue

EOA




#------------------------------------------------
# create cut executable jobs
#------------------------------------------------
cat >> /store/bl2/scratch/$user/${AnaDirectory}/condorfile/job_cut_$ijob <<-EOA
Universe   = vanilla
Executable = /store/bl2/scratch/$user/${AnaDirectory}/condorfile/batch_cut_$ijob.sh
Log        = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_cut_$ijob.log
Output     = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_cut_$ijob.out
Error      = /store/bl2/scratch/$user/${AnaDirectory}/condorlog/batch_cut_$ijob.err
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
# create subtract code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/subtract_$ijob.C <<-EOA

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
   TTree * tree = new TTree ("tree", "tree");



   UInt_t  evt;
   UInt_t  evtnum;
   UInt_t  trig;
   double  cal[2][10][50];
   double  sbt[4][64];


   UInt_t  zhangevt;
   UInt_t  zhangevtnum;
   UInt_t  zhangtrig;
   double  zhangsingle[2][10][50];
   double  zhangsbt[4][64];
   double  zhangsum[2][10][50];

   event->SetBranchAddress("evt", &evt);
   event->SetBranchAddress("evtnum", &evtnum);
   event->SetBranchAddress("trig", &trig);
   event->SetBranchAddress("cal", &cal);
   event->SetBranchAddress("sbt", &sbt);

 tree->Branch("zhangtrig",&zhangtrig,"zhangtrig/i");
 tree->Branch("zhangsum",&zhangsum,"zhangsum[2][10][50]/D");
 tree->Branch("zhangsingle",&zhangsingle,"zhangsingle[2][10][50]/D");



  int encal = event->GetEntries();

  for (long i=0; i< encal; ++i)
 {

     event->GetEntry(i);
     zhangtrig=trig;


    for(int l=0;l <2; l++)
   {

    for(int m=0;m <10; m++)
   {

   for(int n=0;n <1; n++)
   {
     int num1 = l*50*10 + m*50 + n;
     int num2 = l*50*10 + m*50 + n+1;
     int num3 = l*50*10 + m*50 + n+2;
     zhangsum[l][m][n] =  cal[l][m][n] - geo[3][num1] +  cal[l][m][n+1] - geo[3][num2] +  cal[l][m][n+2] - geo[3][num3];
   }



  for(int n=1;n <2; n++)
   {
     int num1 = l*50*10 + m*50 + n-1;
     int num2 = l*50*10 + m*50 + n;
     int num3 = l*50*10 + m*50 + n+1;
     int num4= l*50*10 + m*50 + n+2;
     zhangsum[l][m][n] =  cal[l][m][n-1] - geo[3][num1] +  cal[l][m][n] - geo[3][num2] +  cal[l][m][n+1] - geo[3][num3]
+ cal[l][m][n+2] - geo[3][num4];

   }

  for(int n=48;n <49; n++)
   {
     int num1 = l*50*10 + m*50 + n-2;
     int num2 = l*50*10 + m*50 + n-1;
     int num3 = l*50*10 + m*50 + n;
     int num4= l*50*10 + m*50 + n+1;
     zhangsum[l][m][n] =  cal[l][m][n-2] - geo[3][num1] +  cal[l][m][n-1] - geo[3][num2] +  cal[l][m][n] - geo[3][num3] + cal[l][m][n+1] - geo[3][num4];

   }


  for(int n=49;n <50; n++)
   {
     int num1 = l*50*10 + m*50 + n-2;
     int num2 = l*50*10 + m*50 + n-1;
     int num3 = l*50*10 + m*50 + n;
     zhangsum[l][m][n] =  cal[l][m][n-2] - geo[3][num1] +  cal[l][m][n-1] - geo[3][num2] +  cal[l][m][n] - geo[3][num3];

   }

 for(int n=2;n <48; n++)
   {
     int num1 = l*50*10 + m*50 + n-2;
     int num2 = l*50*10 + m*50 + n-1;
     int num3 = l*50*10 + m*50 + n;
     int num4 = l*50*10 + m*50 + n+1;
     int num5 = l*50*10 + m*50 + n+2;

     zhangsum[l][m][n] = cal[l][m][n-2] - geo[3][num1] + cal[l][m][n-1] - geo[3][num2] + cal[l][m][n] - geo[3][num3] + cal[l][m][n+1] - geo[3][num4] + cal[l][m][n+2] - geo[3][num5];

    }




   for(int n=0;n <50; n++)
   {
     int num = l*50*10 + m*50 + n;
     zhangsingle[l][m][n] = cal[l][m][n] - geo[3][num];
    }


}
}

 tree->Fill();

}




  fout->Write(); 
  fout.Close();
  fin.Close();
}


}


}

EOA



#------------------------------------------------
# create subtract code
#------------------------------------------------

cat >> /store/bl2/scratch/$user/${AnaDirectory}/code/cut_$ijob.C <<-EOA

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
    double cut =100;

    TString fileribbon= Form(zhangname);

    TFile fin(fileribbon + "-shifted.root","READ");
    TFile fout(fileribbon + "-shifted-sum.root","recreate");

    TTree * tree = (TTree *)fin.Get("tree"); 
    TTree * sumtree = new TTree ("sumtree", "sumtree");


   UInt_t  zhangevt;
   UInt_t  zhangevtnum;
   UInt_t  zhangtrig;
   double  zhangsum[2][10][50];
   double  zhangsingle[2][10][50];

   UInt_t  sumevt;
   UInt_t  sumevtnum;
   UInt_t  sumtrig;
   double  sumsum[2][10][50];
   double  sumsingle[2][10][50];

  tree->SetBranchAddress("zhangtrig", &zhangtrig);
  tree->SetBranchAddress("zhangsingle", &zhangsingle);
  tree->SetBranchAddress("zhangsum", &zhangsum);

 sumtree->Branch("sumtrig",&sumtrig,"sumtrig/i");
 sumtree->Branch("sumsingle",&sumsingle,"sumsingle[2][10][50]/D");
 sumtree->Branch("sumsum",&sumsum,"sumsum[50]/D");



 int enbeam = tree->GetEntries();

  for (long i=0; i< enbeam; ++i)
 {


    tree->GetEntry(i);


if(zhangsum[0][0][8] +zhangsum[1][0][8] + zhangsum[0][1][8] + zhangsum[1][1][8] + zhangsum[0][2][8]+zhangsum[1][2][8] + zhangsum[0][3][8] + zhangsum[1][3][8] + zhangsum[0][4][8] + zhangsum[1][4][8]+ zhangsum[0][5][8] + zhangsum[1][5][8] + zhangsum[0][6][8] + zhangsum[1][6][8] + zhangsum[0][7][8] + zhangsum[1][7][8] + zhangsum[0][8][8] + zhangsum[1][8][8] + zhangsum[0][9][8] + zhangsum[1][9][8]> cut )
{


    sumtrig=zhangtrig;



   for(int l=0;l <2; l++)
   {
   for(int m=0;m <10; m++)
   {
   for(int n=0; n <50; n++)
   {

     sumsingle[l][m][n] =  zhangsingle[l][m][n] ;
  }
  }



  }




  sumtree->Fill();

}



}


  fout->Write();
  fout.Close();
  fin.Close();
}

}






}

}

EOA



  let "ijob += 1"
  done
