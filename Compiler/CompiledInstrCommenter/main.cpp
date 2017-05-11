#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

int main(){
    string in;
    vector<string> out;
    ifstream infile("compilado_instrucoes");
    ofstream outfile("compilado_instrucoes_comentado.txt");//, ios::out
    if(!infile.good()||!outfile.good()) return 1;
    while(getline(infile, in)){
        int instr=(in[0]-48)*8+(in[1]-48)*4+(in[2]-48)*2+(in[3]-48);
        switch(instr){
            case 0:in+=" //sleep(id+register - null)";break;
            case 1:in+=" //branch register if equal(id+out - in0+in1)";break;
            case 2:in+=" //branch register if flag (id+out - in0+in1)";break;
            case 3:in+=" //add (id+out - in0+in1)";break;
            case 4:in+=" //sub (id+out - in0+in1)";break;
            case 5:in+=" //and (id+out - in0+in1)";break;
            case 6:in+=" //or (id+out - in0+in1)";break;
            case 7:in+=" //nor (id+out - in0+in1)";break;
            case 8:in+=" //set less on then (id+out - in0+in1)";break;
            case 9:in+=" //shift right >> (id+out - in0+in1)";break;
            case 10:in+=" //shift left << (id+out - in0+in1)";break;
            case 11:in+=" //jump register (id+register - address(if register==0))";break;
            case 12:in+=" //load address (id+register - address)";break;
            case 13:in+=" //load constant (id+register - value)";break;
            case 14:in+=" //load word (id+register - reg_addr+offset)";break;
            case 15:in+=" //store word (id+register - reg_addr+offset)";break;
            default: in+=" //UNKNOWN 404";break;
        }
        out.push_back(in);
    }
    for(int i=0;i<out.size();i++)
        outfile<<out[i]<<endl;
    infile.close();
    outfile.close();
    return 0;
}
