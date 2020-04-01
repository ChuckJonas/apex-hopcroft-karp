public class ArrayUtil {

    // method needed to replicate java Integer[len], because apex initialized with null values instead of 0
    public static Integer[] initializeFixedIntArray(Integer len){
      Integer[] iArr = new Integer[len];
      for(Integer i = 0; i < len; i++){
        iArr[i] = 0;
      }
      return iArr;
    }
}
