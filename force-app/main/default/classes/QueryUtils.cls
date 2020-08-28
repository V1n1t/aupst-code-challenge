/**
 * @Author             : Vineeth Batreddy
 * @Description        : This class holds all the query / soql related utility methods
**/

public without sharing class QueryUtils {

	public class Filter {
		public String name {get; set;}
		public String operator {get; set;}
		public List<String> value {get; set;}
	}

	/* retrieves all fields on a given sObject applying filters supplied - returns only 1 record */
	public static SObject getRecord(String objectName, Map<String, String> filters, String additionalFields) {
		List<SObject> records = getRecords(objectName, filters, additionalFields);
		if(records.size()>0)
			return records.get(0);
		else
			return null;
	}

	/* retrieves all fields on a given sObject applying simple filters supplied */
	public static List<SObject> getRecords(String objectName, Map<String, String> filters, String additionalFields) {
		
		List<SObject> records = getRecords(objectName, filters, additionalFields, null);
		return records;
	}

	/* retrieves all fields on a given sObject applying simple filters supplied. allows for ordering the records */
	public static List<SObject> getRecords(String objectName, Map<String, String> filters, String additionalFields, string order) {
		
		String query = generateSimpleQuery(objectName, filters, additionalFields, order);
		
		List<SObject> records = Database.query(query);
		return records;
	}

	/* retrieves all fields on a given sObject applying filters supplied - returns only 1 record, avoids record locking */
	public static SObject getRecordForUpdate(String objectName, Map<String, String> filters, String additionalFields) {
		List<SObject> records = getRecordsForUpdate(objectName, filters, additionalFields);
		if(records.size()>0)
			return records.get(0);
		else
			return null;
	}

	/* retrieves all fields on a given sObject applying simple filters supplied. allows for ordering the records. avoids record locking */
	public static List<SObject> getRecordsForUpdate(String objectName, Map<String, String> filters, String additionalFields) {
		
		String query = generateSimpleQuery(objectName, filters, additionalFields, null) + ' FOR UPDATE';

		List<SObject> records = Database.query(query);
		return records;
	}

	/* retrieves all fields on a given sObject applying complex filters supplied. allows for ordering the records */
	public static List<SObject> getRecords(String objectName, List<filter> filters, String additionalFields, string order) {
		
		String query = generateComplexQuery(objectName, filters, additionalFields, order);

		List<SObject> records = Database.query(query);
		return records;
	}

	/* retrieves all fields on a given sObject applying complex filters supplied. allows for ordering the records */
	public static List<SObject> getRecordsForUpdate(String objectName, List<filter> filters, String additionalFields) {
		
		String query = generateComplexQuery(objectName, filters, additionalFields, null) + ' FOR UPDATE';

		List<SObject> records = Database.query(query);
		return records;
	}

	/* retrieves all fields on a given sObject and returns it as a comma seperated string */
	public static String getCommaSeperatedFields(String objectName) {
		return String.join(new List<String>(Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().keySet()), ',');
	}

	/* constructs an ordered query with all fields on an sObject by applying simple filters supplied*/
	public static String generateSimpleQuery(String objectName, Map<String, String> filters, String additionalFields, string order) {
		String commaSeperatedFields = getCommaSeperatedFields(objectName);
		
		if(String.isNotBlank(additionalFields))
			commaSeperatedFields = commaSeperatedFields +','+additionalFields;

		String query = 'SELECT ' + commaSeperatedFields + ' FROM ' + objectName;
		if(filters != null && filters.size()>0) {
			query = query + ' WHERE ';

			List<String> filterConditions = new List<String>();
			List<String> keySet = new List<String>(filters.keySet());
			for(String key : keySet) {
				String filterName = key;
				String filterValue = filters.get(filterName);
				String filter = filterName + ' = ' + '\''+filterValue+'\'';
				filterConditions.add(filter);
			}

			for(Integer i=0; i<filterConditions.size(); i++) {
				query = query + filterConditions.get(i);
				if(i < filterConditions.size()-1)
					query = query + ' AND ';
			}
			
			if(order!=null && order!='')
				query += ' '+order;

		}

		return query;
	}

	/* constructs an ordered query with all fields on an sObject by applying complex filters supplied*/
	public static String generateComplexQuery(String objectName, List<filter> filters, String additionalFields, string order) {
		String commaSeperatedFields = getCommaSeperatedFields(objectName);
		
		if(String.isNotBlank(additionalFields))
			commaSeperatedFields = commaSeperatedFields +','+additionalFields;

		String query = 'SELECT ' + commaSeperatedFields + ' FROM ' + objectName;
		if(filters != null && filters.size()>0) {
			query = query + ' WHERE ';

			List<String> filterConditions = new List<String>();
			for(Filter filter : filters) {
				
				String filterName = filter.name;
				String filterOperator = filter.operator;
				String filterValue = '';

				if(filter.value.size()==1)
					filterValue =  '\''+filter.value.get(0)+'\'';
				else if(filter.value.size()>1) {
					for(String value : filter.value) {
						filterValue = filterValue + '\''+value+'\',';
					}
					filterValue = filterValue.substring(0, filterValue.length()-1);
				}
				filterValue = '('+filterValue+')';

				filterConditions.add(filterName+' '+filterOperator+' '+filterValue);
			}

			for(Integer i=0; i<filterConditions.size(); i++) {
				query = query + filterConditions.get(i);
				if(i < filterConditions.size()-1)
					query = query + ' AND ';
			}
			
			if(order!=null && order!='')
				query += ' '+order;

		}

		return query;
	}

}