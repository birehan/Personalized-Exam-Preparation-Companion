# !pip install pymongo
import json
import pymongo

def read_file(file_path):
    # Open the .json file and load the data
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def remove_keys(data, keys):
    for item in data:
        for col in keys:
            if col in item:
                del item[col]
    return data


def rename_keys(data):
    for item in data:
        for key, value in item.items():
            if isinstance(value, dict):
                item[key] = list(item[key].values())[0]
    return data
    

def insert_into_db(mongo_url, data_infos):
    client = pymongo.MongoClient(mongo_url)
    db_name = mongo_url.split('/')[-1]  # Extracting the db name from the URL
    db = client[db_name] 
    
    for i in range(len(data_infos)):
        data = read_file(data_infos[i]["file_path"])
        data = remove_keys(data, data_infos[i]["keys_to_remove"])
        data = rename_keys(data)
        
        collection = db[data_infos[i]["collection_name"]]
        for item in data:
            is_valid = True
            for ref_col, ref_id in data_infos[i]["reference_data"]:
                if ref_id not in item:
                    is_valid = False
                    break

                ref_collection = db[ref_col]
                ref_valid = ref_collection.find_one({"_id": item[ref_id]})
                if ref_valid is None:
                    is_valid = False
                    break
            
            if is_valid:
                existing_document = collection.find_one({'_id': item['_id']})
                if existing_document is None:
                    collection.insert_one(item) 