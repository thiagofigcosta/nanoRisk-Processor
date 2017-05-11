#include <iostream>
#include <bitset>
#include <algorithm>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <map>

using namespace std;

string output = "a.out";
string input;
map<string,int> addresses;

int nRisk_StackSigal=-1;
//funcs
string nRisk_slp="0000";
string nRisk_brq="0001";
string nRisk_brf="0010";
string nRisk_add="0011";
string nRisk_sub="0100";
string nRisk_and="0101";
string nRisk_or ="0110";
string nRisk_nor="0111";
string nRisk_slt="1000";
string nRisk_sr ="1001";
string nRisk_sl ="1010";
string nRisk_jr ="1011";
string nRisk_la ="1100";
string nRisk_lc ="1101";
string nRisk_lw ="1110";
string nRisk_sw ="1111";
//regs
string nRisk_zro="0000";
string nRisk_flg="0001";
string nRisk_nt ="0010";
string nRisk_sp ="0011";
string nRisk_ra ="0100";
string nRisk_v0 ="0101";
string nRisk_v1 ="0110";
string nRisk_a0 ="0111";
string nRisk_a1 ="1000";
string nRisk_a2 ="1001";
string nRisk_a3 ="1010";
string nRisk_s0 ="1011";
string nRisk_s1 ="1100";
string nRisk_s2 ="1101";
string nRisk_s3 ="1110";
string nRisk_bp ="1111";

void error(string str){
	cout<<"error - "<<str<<"."<<endl;
}

struct nanoArg{
    string arg;
    bool isRegister;
    int pos;
    bool err=false;
};

int strToInt(string str){
    stringstream ss;
    ss.str(str);
    int out;
    ss>>out;
    return out;
}

bool isValidChar(char c){
    return c=='$'||(c>=48&&c<=57)||(c>=65&&c<=90)||(c>=97&&c<=122);
}

bool isBinary(string str){
    for(int i=0;i<str.size();i++){
        if(str[i]!='0'&&str[i]!='1'){
            return false;
        }
    }
    return true;
}
nanoArg getArgFrom(string str, int from){
    nanoArg out;
    int start=-1;
    for(int j=from;j<=str.size();j++){
        if(start<0&&isValidChar(str[j])){
            start=j;
        }else if(start>=0){
            if(str[j]==','||str[j]=='\0'||str[j]=='\t'||str[j]=='('||str[j]==')'||str[j]==' '){
                out.pos=j+1;
                out.arg=str.substr(start,j-start);
                out.isRegister=out.arg.find("$")!=string::npos;
                return out;
            }
        }
    }
    out.err=true;
    return out;
}
string translateRegister(string arg){
    arg.erase(remove(arg.begin(),arg.end(),'$'),arg.end());//remove $
    if(!arg.compare("zero")||!arg.compare("0")){
        return nRisk_zro;
    }else if(!arg.compare("flg")||!arg.compare("flag")){
        return nRisk_flg;
    }else if(!arg.compare("nt")||!arg.compare("nT")){
        return nRisk_nt;
    }else if(!arg.compare("sp")){
        return nRisk_sp;
    }else if(!arg.compare("ra")){
        return nRisk_ra;
    }else if(!arg.compare("v0")){
        return nRisk_v0;
    }else if(!arg.compare("v1")){
        return nRisk_v1;
    }else if(!arg.compare("a0")){
        return nRisk_a0;
    }else if(!arg.compare("a1")){
        return nRisk_a1;
    }else if(!arg.compare("a2")){
        return nRisk_a2;
    }else if(!arg.compare("a3")){
        return nRisk_a3;
    }else if(!arg.compare("s0")){
        return nRisk_s0;
    }else if(!arg.compare("s1")){
        return nRisk_s1;
    }else if(!arg.compare("s2")){
        return nRisk_s2;
    }else if(!arg.compare("s3")){
        return nRisk_s3;
    }else if(!arg.compare("bp")){
        return nRisk_bp;
    } else return "";
}
vector<string> translateFunc(string func,string args){
    func.erase(remove(func.begin(),func.end(),' '),func.end());//remove spaces
    args.erase(remove(args.begin(),args.end(),' '),args.end());//remove spaces
    func.erase(remove(func.begin(),func.end(),'\t'),func.end());//remove spaces
    args.erase(remove(args.begin(),args.end(),'\t'),args.end());//remove spaces
    vector<string> out;
    nanoArg arg0,arg1,arg2;
    string nRisk,argRegister,target0,target1,target2;
    if(!func.compare("slp")||!func.compare("sleep")){
        arg0=getArgFrom(args,0);
        target0="0001";
        if(!arg0.err){
            if(arg0.isRegister){
                argRegister=translateRegister(arg0.arg);
                if(argRegister!="")
                    target0=argRegister;
                else{
                    error("Register \""+arg0.arg+"\" doesnt exists");
                    return out;
                }
            }
        }
        out.push_back(nRisk_slp+target0);
        out.push_back("00000000");
        return out;
    }else if(!func.compare("brq")||!func.compare("brf")||!func.compare("add")||!func.compare("sub")||!func.compare("and")
             ||!func.compare("or")||!func.compare("nor")||!func.compare("slt")||!func.compare("sr")||!func.compare("sl")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        arg1=getArgFrom(args,arg0.pos);
        if(arg1.err){
            error("Cannot find arg1 for \""+func+"\"");
            return out;
        }
        if(!arg1.isRegister){
            error("Arg1 for \""+func+"\" is not a register");
            return out;
        }
        arg2=getArgFrom(args,arg1.pos);
        if(arg2.err){
            error("Cannot find arg2 for \""+func+"\"");
            return out;
        }
        if(!arg2.isRegister){
            error("Arg2 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        argRegister=translateRegister(arg1.arg);
        if(argRegister==""){
            error("Register \""+arg1.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target1=argRegister;
        argRegister=translateRegister(arg2.arg);
        if(argRegister==""){
            error("Register \""+arg2.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target2=argRegister;
        
        if(!func.compare("brq"))
            nRisk=nRisk_brq;
        else if(!func.compare("brf"))
            nRisk=nRisk_brf;
        else if(!func.compare("add"))
            nRisk=nRisk_add;
        else if(!func.compare("sub"))
            nRisk=nRisk_sub;
        else if(!func.compare("and"))
            nRisk=nRisk_and;
        else if(!func.compare("or"))
            nRisk=nRisk_or;
        else if(!func.compare("nor"))
            nRisk=nRisk_nor;
        else if(!func.compare("slt"))
            nRisk=nRisk_slt;
        else if(!func.compare("sr"))
            nRisk=nRisk_sr;
        else if(!func.compare("sl"))
            nRisk=nRisk_sl;

        out.push_back(nRisk+target0);
        out.push_back(target1+target2);
        return out;
    }else if(!func.compare("jr")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        out.push_back(nRisk_jr+target0);
        out.push_back("00000000");
        return out;
    }else if(!func.compare("j")){//SEMI INTERPRETADA
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(arg0.isRegister){
            error("Arg0 for \""+func+"\" is a register");
            return out;
        }
        out.push_back(nRisk_jr+"0000");
        out.push_back(arg0.arg);
        return out;
    }else if(!func.compare("la")||!func.compare("lc")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        arg1=getArgFrom(args,arg0.pos);
        if(arg1.err){
            error("Cannot find arg1 for \""+func+"\"");
            return out;
        }
        if(arg1.isRegister){
            error("Arg1 for \""+func+"\" is a register");
            return out;
        }
        if(!func.compare("la")){
            out.push_back(nRisk_la+target0);
            out.push_back(arg1.arg);
        }else if(!func.compare("lc")){
            if(strToInt(arg1.arg)>255){
                error("Constant overflow, your constant should be less than 256");
                return out;
            }
            out.push_back(nRisk_lc+target0);
            out.push_back(bitset< 8 >(strToInt(arg1.arg)).to_string());
        }
        return out;
    }else if(!func.compare("lw")||!func.compare("sw")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        arg1=getArgFrom(args,arg0.pos);
        if(arg1.err){
            error("Cannot find arg1 for \""+func+"\"");
            return out;
        }
        if(arg1.isRegister){
            error("Arg1 for \""+func+"\" is a register");
            return out;
        }
        arg2=getArgFrom(args,arg1.pos);
        if(arg2.err){
            error("Cannot find arg2 for \""+func+"\"");
            return out;
        }
        if(!arg2.isRegister){
            error("Arg2 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg2.arg);
        if(argRegister==""){
            error("Register \""+arg2.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target2=argRegister;
        
        if(!func.compare("lw"))
            nRisk=nRisk_lw;
        else if(!func.compare("sw"))
            nRisk=nRisk_sw;
        if(strToInt(arg1.arg)>15){
            error("Offset \""+arg1.arg+"\" for \""+func+"\" should be less than 16");
            return out;
        }
        out.push_back(nRisk+target0);
        out.push_back(bitset< 4 >(strToInt(arg1.arg)).to_string()+target2);
        return out;
    }//INTERPRETADAS
    else if(!func.compare("addc")||!func.compare("andc")||!func.compare("orc")||!func.compare("norc")||
            !func.compare("sltc")||!func.compare("src")||!func.compare("slc")||!func.compare("beq")||
            !func.compare("bof")){
        
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        arg1=getArgFrom(args,arg0.pos);
        if(arg1.err){
            error("Cannot find arg1 for \""+func+"\"");
            return out;
        }
        if(!arg1.isRegister){
            error("Arg1 for \""+func+"\" is not a register");
            return out;
        }
        arg2=getArgFrom(args,arg1.pos);
        if(arg2.err){
            error("Cannot find arg2 for \""+func+"\"");
            return out;
        }
        if(arg2.isRegister){
            error("Arg2 for \""+func+"\" is a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        argRegister=translateRegister(arg1.arg);
        if(argRegister==""){
            error("Register \""+arg1.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target1=argRegister;
        if(func.compare("beq")&&func.compare("bof"))
        if(strToInt(arg2.arg)>255){
            error("Constant overflow, your constant should be less than 256");
            return out;
        }
        out.push_back(nRisk_lc+nRisk_nt);
        if(!func.compare("beq")||!func.compare("bof")){
            out.push_back(arg2.arg);
        }else{
            out.push_back(bitset< 8 >(strToInt(arg2.arg)).to_string());
        }
        if(!func.compare("addc"))
            nRisk=nRisk_add;
        else if(!func.compare("andc"))
            nRisk=nRisk_and;
        else if(!func.compare("orc"))
            nRisk=nRisk_or;
        else if(!func.compare("norc"))
            nRisk=nRisk_nor;
        else if(!func.compare("sltc"))
            nRisk=nRisk_slt;
        else if(!func.compare("src"))
            nRisk=nRisk_sr;
        else if(!func.compare("slc"))
            nRisk=nRisk_sl;
        else if(!func.compare("beq"))
            nRisk=nRisk_brq;
        else if(!func.compare("bof"))
            nRisk=nRisk_brf;
        out.push_back(nRisk+target0);
        out.push_back(target1+nRisk_nt);
        return out;
    }else if(!func.compare("mov")||!func.compare("move")||!func.compare("not")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        arg1=getArgFrom(args,arg0.pos);
        if(arg1.err){
            error("Cannot find arg1 for \""+func+"\"");
            return out;
        }
        if(!arg1.isRegister){
            error("Arg1 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        argRegister=translateRegister(arg1.arg);
        if(argRegister==""){
            error("Register \""+arg1.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target1=argRegister;
        
        if(!func.compare("mov")||!func.compare("move"))
            nRisk=nRisk_add;
        else if(!func.compare("not"))
            nRisk=nRisk_nor;
        
        
        out.push_back(nRisk+target0);
        out.push_back(target1+nRisk_zro);
        return out;

    }else if(!func.compare("jal")||!func.compare("jrl")){
        if(!func.compare("jal")){
            arg0=getArgFrom(args,0);
            if(arg0.err){
                error("Cannot find arg0 for \""+func+"\"");
                return out;
            }
            if(arg0.isRegister){
                error("Arg0 for \""+func+"\" is a register");
                return out;
            }
            target0=nRisk_nt;
            out.push_back(nRisk_lc+target0);
            out.push_back(arg0.arg);
        }else{
            arg0=getArgFrom(args,0);
            if(arg0.err){
                error("Cannot find arg0 for \""+func+"\"");
                return out;
            }
            if(!arg0.isRegister){
                error("Arg0 for \""+func+"\" is not a register");
                return out;
            }
            argRegister=translateRegister(arg0.arg);
            if(argRegister==""){
                error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
                return out;
            }
            target0=argRegister;
        }
        out.push_back(nRisk_jr+target0);
        out.push_back("00000000");
        out.push_back(nRisk_add+nRisk_ra);
        out.push_back(nRisk_nt+nRisk_zro);
        return out;
    }else if(!func.compare("push")||!func.compare("pop")){
        arg0=getArgFrom(args,0);
        if(arg0.err){
            error("Cannot find arg0 for \""+func+"\"");
            return out;
        }
        if(!arg0.isRegister){
            error("Arg0 for \""+func+"\" is not a register");
            return out;
        }
        argRegister=translateRegister(arg0.arg);
        if(argRegister==""){
            error("Register \""+arg0.arg+"\" doesnt exists for \""+func+"\"");
            return out;
        }
        target0=argRegister;
        if(nRisk_StackSigal>0){
            if(!func.compare("push")){
                //escreve soma
                out.push_back(nRisk_sw+target0);
                out.push_back("0000"+nRisk_sp);
                out.push_back(nRisk_lc+nRisk_nt);
                out.push_back(bitset< 8 >(1).to_string());
                out.push_back(nRisk_add+nRisk_sp);
                out.push_back(nRisk_sp+nRisk_nt);
            }else{
                //subtrai le
                out.push_back(nRisk_lc+nRisk_nt);
                out.push_back(bitset< 8 >(1).to_string());
                out.push_back(nRisk_sub+nRisk_sp);
                out.push_back(nRisk_sp+nRisk_nt);
                out.push_back(nRisk_lw+target0);
                out.push_back("0000"+nRisk_sp);
            }
        }else{
            if(!func.compare("push")){
                //subtrai escreve
                out.push_back(nRisk_lc+nRisk_nt);
                out.push_back(bitset< 8 >(1).to_string());
                out.push_back(nRisk_sub+nRisk_sp);
                out.push_back(nRisk_sp+nRisk_nt);
                out.push_back(nRisk_sw+target0);
                out.push_back("0000"+nRisk_sp);
            }else{
                //le soma
                out.push_back(nRisk_lw+target0);
                out.push_back("0000"+nRisk_sp);
                out.push_back(nRisk_lc+nRisk_nt);
                out.push_back(bitset< 8 >(1).to_string());
                out.push_back(nRisk_add+nRisk_sp);
                out.push_back(nRisk_sp+nRisk_nt);
            }
        }
        return out;
    }else{
        error("Function \""+func+"\" doesnt exists");
        return out;
    }
}

int main(int argc, char **argv){
	if(argc<2){
		error("No such file or arguments");
		return -1;
	}
	input=argv[1];
	for(int i=2;i<argc;i++){
		if(argv[i][0]=='-'&&argv[i][1]=='o'){
			output=argv[++i];
		}
	}
	string line;
	vector<string> code;
	ifstream codeFile (input);
	if (codeFile.is_open()){
	    while (getline (codeFile,line)){
	    	code.push_back(line);
	    }
	    codeFile.close();
  	}else{
  		error("Unable to reach file");
		return -1;
  	}
  	vector<string> machineCode;
    vector<string> dataSeg;
    string dataSegSize;
  	bool data=false;
  	bool text=false;
    int commentedLines=0;
    for(int i=0;i<code.size();i++){
        if(code[i][0]=='#'||code[i][0]=='\n'){
            code.erase(code.begin()+i);
            i--;
            commentedLines++;
        }else{
            int foundAt=code[i].find("#");//size
            if(foundAt!=string::npos){
                code[i].erase(code[i].begin()+foundAt,code[i].end());
            }
        }
    }
    int currentAddress=0;
    int currentDataAddress=0;
    int doubleDotAt;
    for(int i=0;i<code.size();i++){
        if(code[i].find(".data")!=string::npos){
            data=true;
        }else if(code[i].find(".text")!=string::npos){
            text=true;
        }else if(data&&!text){//MERGE DATA WITH MACHINE CODE
            doubleDotAt=code[i].find(":");//size
            if(doubleDotAt==string::npos)
                doubleDotAt=0;
            else{
                string tmp=code[i].substr(0,doubleDotAt);
                code[i]=code[i].substr(doubleDotAt+1);
                tmp.erase(remove(tmp.begin(),tmp.end(),' '),tmp.end());
                tmp.erase(remove(tmp.begin(),tmp.end(),'\t'),tmp.end());
                addresses[tmp]=currentDataAddress;
            }
            code[i]=code[i].substr(code[i].find("."));
            string varType=code[i].substr(0,code[i].find(" "));
            if(!varType.compare(".word")){
                code[i]=code[i].substr(code[i].find(" "));
                code[i].erase(remove(code[i].begin(),code[i].end(),' '),code[i].end());//remove spaces
                code[i].erase(remove(code[i].begin(),code[i].end(),'\t'),code[i].end());//remove spaces
                int last=0;
                for(int j=0;j<=code[i].size();j++){
                    if(code[i][j]==','||code[i][j]=='\0'){
                        dataSeg.push_back(bitset< 8 >(strToInt(code[i].substr(last,j-last))).to_string());
                        last=j;
                        currentDataAddress++;
                    }
                }
            }
        }else if(text){
            doubleDotAt=code[i].find(":");//size
            if(doubleDotAt==string::npos)
                doubleDotAt=0;
            else{
                string tmp=code[i].substr(0,doubleDotAt);
                tmp.erase(remove(tmp.begin(),tmp.end(),' '),tmp.end());
                tmp.erase(remove(tmp.begin(),tmp.end(),'\t'),tmp.end());
                addresses[tmp]=currentAddress;
            }
            int start=-1;
            for(int j=doubleDotAt;j<=code[i].size();j++){
                if(start<0&&isValidChar(code[i][j])){
                    start=j;
                }else if(start>=0){
                    if(code[i][j]==' '||code[i][j]=='\0'||code[i][j]=='\t'){
                        vector<string> translated=translateFunc(code[i].substr(start,j-start),code[i].substr(j+1));
                        if(translated.size()!=0){
                            for(int t=0;t<translated.size();t++){
                                machineCode.push_back(translated[t]);
                                currentAddress++;
                            }
                        }else{
                            error("Translating line ("+to_string(i+commentedLines)+")");
                            return -1;
                        }
                         break;
                    }
                }
            }

        }
    }
    for(int i=1;i<machineCode.size();i+=2)
        if(machineCode[i].size()!=8||!isBinary(machineCode[i])){
            if(addresses.find(machineCode[i]) == addresses.end()){
                error("Cannot jump to \""+machineCode[i]+"\", tag doesnt exists");
                return -1;
            }else{
                if(addresses[machineCode[i]]>255){
                    error("Address overflow("+to_string(addresses[machineCode[i]])+"), your code is too big");
                    return -1;
                }
                machineCode[i]=bitset< 8 >(addresses[machineCode[i]]).to_string();
            }
        }
    dataSegSize=bitset< 8 >(dataSeg.size()).to_string();
    machineCode.insert(machineCode.begin(), dataSegSize);
    for(int i=0;i<dataSeg.size();i++){
        machineCode.insert(machineCode.begin(), dataSeg[i]);
    }
  	ofstream machineFile (output);
	if (machineFile.is_open()){
	    for(int i=0;i<machineCode.size();i++){
            machineFile<<machineCode[i]<<" ";
            if((i+1)%2==0&&i+1<machineCode.size())
                machineFile<<endl;
        }
	    machineFile.close();
	}else{
		error("Unable to create file");
		return -1;
	}
	return 0;
}
