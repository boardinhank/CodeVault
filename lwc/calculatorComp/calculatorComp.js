import { LightningElement } from 'lwc';
export default class CalculatorComp extends LightningElement {
//Define properties - private
firstNumber=20; //undefined
secondNumber=10; 
result;

//Define method

add(){
    this.result = this.firstNumber + this.secondNumber;
}

sub(){
    this.result = this.firstNumber - this.secondNumber;
}

mult(){
    this.result = this.firstNumber * this.secondNumber;
}

div(){
    this.result = this.firstNumber / this.secondNumber;
}
}