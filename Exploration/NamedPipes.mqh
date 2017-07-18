//+------------------------------------------------------------------+
//|                                                   PipeServer.mq4 |
//|                             Copyright © 2010, Stephen Ambatoding |
//|                                        sangmane@forexfactory.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Stephen Ambatoding"
#property link      "sangmane@forexfactory.com"

#define ERROR_MORE_DATA 234

#import "kernel32.dll"
   bool WaitNamedPipeW(string name, int nTimeOut);
	int CallNamedPipeW(string PipeName, string outBuffer, int outBufferSz, int& inBuffer[], int inBufferSz, int& bytesRead[], int timeOut);
#import

string listenServer(string pipe, string message_to_send){
	string PipeName = "\\\\.\\pipe\\"+pipe;
	int inBuffer[65536];
	int bytesRead[1];
	string inString = "";
	if (WaitNamedPipeW(PipeName, 3000)){
   	bool fSuccess = CallNamedPipeW(PipeName, message_to_send, 2*StringLen(message_to_send),inBuffer,4*ArraySize(inBuffer),bytesRead,0) != 0;
   	int lastError = GetLastError();
   	if (fSuccess || lastError == ERROR_MORE_DATA) { 
   		for(int i=0; i<bytesRead[0]; i++)
   			inString = inString + CharToStr( (inBuffer[i/4] >> ((i & 3)*8)) & 0xff);		
   	   if (inString != "Nothing"){
   	      Print(1);
   	   }   	   
   	}
	}
	return inString;
}

