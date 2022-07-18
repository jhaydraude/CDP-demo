List<isvcdptest2__ISV_Order__c> Orders = new List<isvcdptest2__ISV_Order__c>();
List<Contact> OrderContacts = [select id  from Contact where isvcdptest2__Languages__c != null];

for (Integer i = 0; i<20; i++) {
    Decimal amt = Math.random() * 1500;    
Contact con = OrderContacts[Integer.valueOf(Math.random()*(OrderContacts.size()-1))];
isvcdptest2__ISV_Order__c Order = new isvcdptest2__ISV_Order__c();
Order.isvcdptest2__Order_Amount__c = amt.setScale(2);
Order.isvcdptest2__Order_Date_Time__c = DateTime.now().addMinutes(Integer.valueOf(Math.random() * -300000));
Order.isvcdptest2__Contact_Id__c = con.id;
Orders.add(Order);
}
insert Orders;

List<isvcdptest2__ISV_Transaction__c> txns = new List<isvcdptest2__ISV_Transaction__c>();

for (isvcdptest2__ISV_Order__c o: Orders) {
    Integer numTransactions = Integer.valueOf(Math.floor(Math.random() * 3));
    Decimal balance = o.isvcdptest2__Order_Amount__c;
    Decimal txnAmt = 0;
    if (numTransactions > 0) {
        txnAmt = balance / numTransactions; 
    }
    if (Math.random() > 0.8) // 80% are paid off fully
    {
         txnAmt = txnAmt * Math.random();

    }
    
    for (Integer i = 0; i < numTransactions; i++) {

        isvcdptest2__ISV_Transaction__c txn = new isvcdptest2__ISV_Transaction__c();
        txn.isvcdptest2__ISV_Order__c = o.id;
        String txnStatus = 'Approved';
        Decimal txnStatRnd = Math.random();
        if (txnStatRnd > 0.95) {
            txnStatus = 'Declined';
        }
        else if (txnStatRnd > 0.9) {
            txnStatus = 'Error';
        }
        txn.isvcdptest2__Response_Status__c = txnStatus;
        txn.isvcdptest2__Transaction_Amount__c = txnAmt;
        String txnType = 'Charge';
        Decimal txnTypeRnd = Math.random();
        if (txnTypeRnd > 0.95) {
            txnType = 'Refund';
        }
        else if (txnTypeRnd > 0.90) {
            txnType = 'void';
        }
        txn.isvcdptest2__Transaction_Type__c = txnType;
        txn.isvcdptest2__Transaction_Date_Time__c = DateTime.now().addMinutes(Integer.valueOf(Math.random() * -300000));
        txns.add(txn);
    } 
}

Insert txns;