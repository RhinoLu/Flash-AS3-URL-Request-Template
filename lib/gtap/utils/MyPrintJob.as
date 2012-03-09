package gtap.utils 
{
	import flash.display.Sprite;
	import flash.printing.PrintJob;
	
	public function MyPrintJob(sp:Sprite):void
	{
		var myPrintJob:PrintJob = new PrintJob();
		if (myPrintJob.start()) {
			//trace(myPrintJob.pageWidth, myPrintJob.pageHeight);
			//trace(myPrintJob.paperWidth, myPrintJob.paperHeight);
			try {
				if (sp.width / myPrintJob.pageWidth > sp.height / myPrintJob.pageHeight) {
					sp.width = myPrintJob.pageWidth;
					sp.scaleY = sp.scaleX;
				}else {
					sp.height = myPrintJob.pageHeight;
					sp.scaleX = sp.scaleY;
				}
				myPrintJob.addPage(sp);
			}
			catch(e:Error) {
				// handle error 
			}
		}
		myPrintJob.send();
	}
}





