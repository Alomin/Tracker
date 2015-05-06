import flask
import json
import requests
import pymongo
from pymongo import MongoClient
from cryptography.fernet import Fernet
import time

application = flask.Flask(__name__)



def generate():
	res = Fernet.generate_key()[:6]
	tmp = ''
	for i in range(len(res)):tmp += chr(ord(res[i])-ord('A')+ord('a')) if 'A' <= res[i] <='Z' else res[i]
	res = tmp
	return res


@application.route('/',methods=['GET', 'POST'])
def listener():
	if flask.request.headers["Message_Type"] == 'getPW':
		key = generate()
		while key in ids:
			key = generate()
		ids[key] = (None,time.time()-15)
	elif flask.request.headers["Message_Type"] == 'upLoad':
		usrid = flask.request.headers["usrid"]
		ids[usrid] = (flask.request.data,time.time())
	elif flask.request.headers["Message_Type"] == 'download':
		try: 
			targetId = flask.request.headers["usrid"]
			res = None
			if targetId not in ids:
				res = json.dumps({'longi':'500','lati':'0'})
			else:
				res = ids[targetId][0]
		except: 
			print 'error: fail to load request.data'
		return res

@application.route('/data')
def data():
	return str(flask.request.method)


if __name__ == '__main__':
	ids = {}
	CLIENT = MongoClient('localhost', 27017)
	DB = CLIENT.test_database
	COLLECTION = DB.spotify
	post = {}
	COLLECTION.insert(post)
	application.run(host = '')