# hello.py
import datetime

def main():
    # Get the current timestamp
    now = datetime.datetime.now()
    
    # Print a greeting
    print(f"Hello, DevOps World!")
    print(f"Current Time: {now.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Python is ready for automation.")

if __name__ == "__main__":
    main()
