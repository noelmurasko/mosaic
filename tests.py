#!/usr/bin/env python

import os
import subprocess

def main():
  directory=f".{os.sep}examples"

  passed="PASSED"
  failed="FAILED"

  verbose=True
  #print("\033[<style>;<text_color>;<background_color>mYour Text\033[0m")
  failureCount=0
  failedTests=[]
  asyfiles=[file for file in sorted(os.listdir(directory)) if file.endswith(".asy")]
  totaltests=len(asyfiles)
  print(f"Testing {totaltests} files\n")

  # Iterate through files in the directory
  for j,filename in enumerate(asyfiles):
      if filename.endswith(".asy"):
          filepath = os.path.join(directory, filename)
          # Run the command on the file
          try:
              subprocess.run(["asy", filepath,"-noV"], stdout=subprocess.DEVNULL,  stderr=subprocess.STDOUT,check=True)
              if verbose:
                print(f'{f"{j+1}. {filename}":<30} {passed:>10}')
          except subprocess.CalledProcessError as e:
              print(f'{f"{j+1}. {filename}":<30} {failed:>10}')
              failureCount+=1
              failedTests.append(filename)


  if len(failedTests) > 0:
    print(f"\n{failureCount} out of {totaltests} tests failed:")
    for test in failedTests:
      print(test)
  else:
    print("\nAll tests passed!")


if __name__ == "__main__":
  main()
