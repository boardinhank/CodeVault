import { LightningElement, wire, track ,api} from 'lwc';
import TransactionSummary_OBJECT from '@salesforce/schema/Transaction_Summary__c';
import getAPITransactionList from '@salesforce/apex/APITransactionCls.getApiTransactionList';
import template from "./viewApiTransactionAccordion.html";

export default class viewApiTransactionAccordion extends LightningElement {
	
    @track jsonStringReq;
	@track jsonStringResponse;
	@api recordId;
    @track reqJson = "Request JSON";
    @track respJson = "Response JSON";
	
	//To get the values from Buylow API transaction record detials
	@wire(getAPITransactionList,{transId:'$recordId'}) apiTransaction({ error, data }) {
        if (data) {
			
			
			if(this.isJson(data.jsonReq)){
				this.jsonStringReq=JSON.stringify(JSON.parse(data.jsonReq),'',2); 
			}else if(this.isXML(data.jsonReq)){ 
				this.jsonStringReq=this.formatXml(data.jsonReq);
			}else if(!this.isJson(data.jsonReq)&& !this.isXML(data.jsonReq) ){
				this.jsonStringReq=data.jsonReq;
			}  
			
			if(data.apistatus=='success' && this.isJson(data.jsonRes)){
                 this.jsonStringResponse = data.jsonRes;
			}
			else if(this.isJson(data.jsonRes)){
                 this.jsonStringResponse=JSON.stringify(JSON.parse(data.jsonRes),'',2); 
			}else if(this.isXML(data.jsonRes)){ 
				this.jsonStringResponse=this.formatXml(data.jsonRes);
			}else if(!this.isJson(data.jsonRes)){
				this.jsonStringResponse=data.jsonRes; 
			}
        } else if (error) {
            this.error = error;
        }
    }

	isJson(str) {
		try {
			JSON.parse(str);
			return true;
		} catch (e) {
			return false;
		}
		
	}
	isXML(xml){
		/* try {
			xmlDoc = $.parseXML(xml); //is valid XML
			return true;
		} catch (err) {
			// was not XML
			return false;
		} */
		 return new window.DOMParser().parseFromString(xml, "text/xml");
		
	}
   
    formatXml(xml) {
		const PADDING = ' '.repeat(2); // set desired indent size here
		const reg = /(>)(<)(\/*)/g;
		let pad = 0;

		xml = xml.replace(reg, '$1\r\n$2$3');

		return xml.split('\r\n').map((node, index) => {
			let indent = 0;
			if (node.match(/.+<\/\w[^>]*>$/)) {
				indent = 0;
			} else if (node.match(/^<\/\w/) && pad > 0) {
				pad -= 1;
			} else if (node.match(/^<\w[^>]*[^\/]>.*$/)) {
				indent = 1;
			} else {
				indent = 0;
			}

			pad += indent;

			return PADDING.repeat(pad - indent) + node;
		}).join('\r\n');
	}
	
    render() {
        return template;
    }
	
	//function to get the detail of open accordion
	handleChange(event) {
        this.openSection =event.detail.openSections; 
    }
	
	//funtion to copy the JSON Request or JSON Response
    copyTo(evt) {
        var inputEle = document.createElement('textarea');
        if(evt.currentTarget.getAttribute("data-value") === this.reqJson) {
            let tempReq = this.template.querySelector(".jsonReq");
            inputEle.textContent = tempReq.textContent;
		}
	    else if(evt.currentTarget.getAttribute("data-value") === this.respJson){
            let tempResp = this.template.querySelector(".jsonResp");
            inputEle.textContent = tempResp.textContent;
		}
        document.body.appendChild(inputEle);
        inputEle.select();
        document.execCommand("copy");
    }
   
}