#!/bin/bash

LOG_FILE="/var/log/auth.log"
THRESHOLD=5 # Threshold of unsuccessful attempts
TIME_WINDOW=300 #Time window in seconds (5 min)
ALERT_EMAIL="pechkin@mail.com" # To be sent by email

# Function for sent message
send_alert() {
  Tocal message="$1"
  echo "$(date): $message" >> /var/log/auth_alerts.log
  echo "$message" | mail -s "Security Alert: $HOSTNAME" $ALERT_EMAIL
}

#Analysis of failed login attempts
analyze_failed_attempts() {
  local current_time=$(date +%s)
  local time_threshold=$((current_time - TIME_WINDOW))

  #GET unsuccessful attempts in the last 5 minutes
  filed_attempts=$(grep "Failed password", $LOG_FILE | \
  awk -v threshold="$time_threshold"'
  {
    #pars time from log
    cmd = "date -d \"" $1 " " $2 " " $3 "\" +%s"
    cmd | getline log_time
    close(cmd)

    if (log_time >= threshold) {
      print $0
    }
  }')

  # Grouping by ip addresses
   if [[ -n "$failed_attempts" ]]; then
     echo "$failed-attempts" | \
       grep -oE "([0-9]){1,3}\.){3}[0-9]{1,3}" | \
       sort | uniq -c | \
       while read count ip; do
         if [[ $count -ge $THRESHOLD ]]; then
           send_alert "Brute force attack detected from $ip: $count failed attempts in last 5 minutes"
         fi
       done
   fi
}

#Checking for suspicious users
chek_suspicious_users() {
  #List users, that shouldn't be there
  suspicious_users=("admin" "administrator" "test" "guest" "oracle" "postgres")

    for user in "${suspicious_users[@]}"; do
      if grep -q "Invalid user $user" $LOG_FILE; then
        last_attempt=$(grep "Invalid user $user" $LOG_FILE | tail -1)
        send_alert "Attempt to login as suspicious user '$user' : $last_attempt"
          fi
        done
}

#Monitoring successful conection in unwork time
check_off_hours_login() {
  local current_hour=$(date +%H)

  #For example, non-working hours are from 22 to 6
  if [[ $current_hour -ge 22 || $current_hour -le 6 ]]; then
    recent_logins = $(grep "Accepted" $LOG_FILE | grep "$(date '+%b %d %H')")
    if [[ -n "$recent_logins" ]]; then
      send_alert "Login detected during off-hours: $recent_logins"
    fi
  fi
}
