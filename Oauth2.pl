#! perl

use 5.010.0;
use strict;
use Data::Dumper;
use MIME::Base64;
use LWP::UserAgent;
use JSON;


sub getUserAgent {

	      #my $proxy = "Your Proxy(Optional)";
        $ENV{PERL_NET_HTTPS_SSL_SOCKET_CLASS} = "Net::SSL";
        $ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;
        #$ENV{HTTPS_PROXY} = $proxy;
	      my $agent = LWP::UserAgent->new();
	      return $agent;
}

sub getAccessToken{

	my $agent = shift; 
	my $clientId = "API key";
	my $clientSecret = "API Secret/Password";
	my $url = 'https://xyz.com'; #API URL
	my $req_token = HTTP::Request->new("POST" => $url); 
	$req_token->header("Accept" => "application/json" ); #Setting Header for POST request  
	$req_token->content_type('application/x-www-form-urlencoded'); #Setting Post Content type to urlencoded format
	my $r="grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret"; #adding data/credentials to POST request based on API documentation
	$req_token->content($r);
	my $res_token = $agent->request($req_token) or croak $!;
	if($res_token->code()!=200)
        {	      
                print "Your Error Message!" ;
		            exit;

        }
	my $response = $res_token->decoded_content;
	my $json = new JSON;
	my $json_text = $json->decode($response);  
	my $token =  $json_text->{'access_token'}; 
  return $token;
  
  #optional based on API
	#my $base64_token = encode_base64($token);    
	#$base64_token = 'Bearer '.$base64_token;
	#return $base64_token;

}

sub getDataFromAPI {
    my $agent = getUserAgent();
		my $token = getAccessToken($agent);
		my $url='https://xyz.com/api/raw?id=12';
    my $req = HTTP::Request->new("GET" => $url);
    $req->header("Accept" => "*/*", "Content-Type" => "application/x-www-form-urlencoded","Authorization" => "$token" );
    $req->content_type('application/x-www-form-urlencoded');
    my $response_raw = $agent->request($req) or croak $!;
		if($response_raw->code()!=200)
                                        {
                                                print "Your ERROR Message!";
                                         } 

     my $response = $response_raw->decoded_content;      
     my $json = new JSON;
     my $json_data = $json->decode($response);
     return $json_data;
       }

my $json_data = getDataFromAPI();
