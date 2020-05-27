/**
 * @File Name          : FlsUtils.cls
 * @Description        :
 * @Author             : agentgill
 * @Group              :
 * @Last Modified By   : agentgill
 * @Last Modified On   : 27/05/2020, 06:59:48
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    24/05/2020   agentgill     Initial Version
 * 1.1    27/05/2020   agentgill     Throw Exception on False & Get Namespace
 
CREATABLE
READABLE
UPDATABLE
UPSERTABLE

 **/
public with sharing class FlsUtils {
    /**
     * @description Check CRUD & FLS
     * @author agentgill | 24/05/2020
     * @param sObj
     * @param fldsToCheck
     * @param flsChecks
     * @return Boolean
     **/

    public static Boolean checkFls(
        sObject sObj,
        String[] fldsToCheck,
        String[] flsChecks
    ) {
        Schema.DescribeSObjectResult describeResult = sObj.getSObjectType()
            .getDescribe();
        Map<String, Schema.SObjectField> fieldMap = describeResult.fields.getMap();
        Boolean runApex = false;
        for (String checks : flsChecks) {
            switch on checks {
                // USE SALESFORCE NEW EMUMS
                when 'CREATEABLE' {
                    if (describeResult.isAccessible()) {
                        for (String fld : fldsToCheck) {
                            if (
                                fieldMap.get(getNamespacePrefix() + fld)
                                    .getDescribe()
                                    .isAccessible()
                            ) {
                                runApex = true;
                            }
                        }
                    }
                }
                // END NEW ENUMS

                when 'isAccessible' {
                    if (describeResult.isAccessible()) {
                        for (String fld : fldsToCheck) {
                            if (
                                fieldMap.get(getNamespacePrefix() + fld)
                                    .getDescribe()
                                    .isAccessible()
                            ) {
                                runApex = true;
                            }
                        }
                    }
                }
                when 'isCreateable' {
                    if (describeResult.isCreateable()) {
                        for (String fld : fldsToCheck) {
                            if (
                                fieldMap.get(getNamespacePrefix() + fld)
                                    .getDescribe()
                                    .isCreateable()
                            ) {
                                runApex = true;
                            }
                        }
                    }
                }
                when 'isUpdateable' {
                    if (describeResult.isUpdateable()) {
                        for (String fld : fldsToCheck) {
                            if (
                                fieldMap.get(getNamespacePrefix() + fld)
                                    .getDescribe()
                                    .isUpdateable()
                            ) {
                                runApex = true;
                            }
                        }
                    }
                }
                when 'isDeleteable' {
                    if (describeResult.isDeletable()) {
                        runApex = true;
                    }
                }
                when else {
                    throw new YourException(
                        'EXCEPTION:Access Type not specified'
                    );
                }
            }
        }
        if (!runApex) {
            throw new YourException('EXCEPTION:FLS Check Failed' + flsChecks);
        }
        return runApex;
    }

    /**
     * @description Get Namespace Prefiex
     * @author agentgill | 24/05/2020
     * @return String
     **/
    private static String getNamespacePrefix() {
        // Available to all users within org
        String ns = null;
        ApexClass ac = [
            SELECT NamespacePrefix
            FROM ApexClass
            WHERE Name LIKE 'YOURNAMESPACE%'
        ];
        if (ac != null) {
            ns = ac.NamespacePrefix + '__';
        }
        return ns;
    }
}
