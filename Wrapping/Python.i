#if SWIGPYTHON
// Make __str__ transparent by renaming ToString to __str__
%rename(__str__) ToString;

%rename( __GetPixelAsUInt8__ ) itk::simple::Image::GetPixelAsUInt8;
%rename( __GetPixelAsInt16__ ) itk::simple::Image::GetPixelAsInt16;
%rename( __GetPixelAsUInt16__ ) itk::simple::Image::GetPixelAsUInt16;
%rename( __GetPixelAsInt32__ ) itk::simple::Image::GetPixelAsInt32;
%rename( __GetPixelAsUInt32__ ) itk::simple::Image::GetPixelAsUInt32;
%rename( __GetPixelAsFloat__ ) itk::simple::Image::GetPixelAsFloat;
%rename( __GetPixelAsDouble__ ) itk::simple::Image::GetPixelAsDouble;


%extend itk::simple::Image {


//      def __floordiv__( other )
//      def __pow__( double s )
//      def __neg__( )
//      def __abs__( )


        %pythoncode %{

# mathematical operators

        def __add__( self, other ):
            if isinstance( other, Image ):
               return Add( self, other )
            return AddConstantTo( self, other )
        def __sub__( self, other ):
            if isinstance( other, Image ):
               return Subtract( self, other )
            return SubtractConstantFrom( self, other )
        def __mul__( self, other ):
            if isinstance( other, Image ):
               return Multiply( self, other )
            return MultiplyByConstant( self, other )
        def __div__( self, other ):
            if isinstance( other, Image ):
               return Divide( self, other )
            return DivideByConstant( self, other )

        def __iadd__ ( self, other ):
            self = Add( self, other )
            return self;

# logic operators

        def __and__( self, other ): return And( self, other )
        def __or__( self, other ): return Or( self, other )
        def __xor__( self, other ): return Xor( self, other )
        def __invert__( self ): return Not( self )

# set/get pixel methods

        def __getitem__( self, idx ):
            """Returns the value of pixel at index idx.
            
            The dimension of idx should match that of the image."""
            pixelID = self.GetPixelIDValue()
            if pixelID == sitkUnknown:
               raise Exception("Logic Error: invalid pixel type")
            if pixelID == sitkUInt8 or pixelID == sitkLabelUInt8:
               return self.__GetPixelAsUInt8__( idx )
            if pixelID == sitkInt16:
               return self.__GetPixelAsInt16__( idx )
            if pixelID == sitkUInt16 or pixelID == sitkLabelUInt16:
               return self.__GetPixelAsUInt16__( idx )
            if pixelID == sitkInt32:
               return self.__GetPixelAsInt32__( idx )
            if pixelID == sitkUInt32 or pixelID == sitkLabelUInt32:
               return self.__GetPixelAsUInt32__( idx )
            if pixelID == sitkFloat32:
               return self.__GetPixelAsFloat__( idx )
            if pixelID == sitkFloat64:
               return self.__GetPixelAsDouble__( idx )
            raise Exception("Unknown pixel type")


        def __setitem__( self, idx, value ):
            """Sets the pixel value at index idx to value.

            The dimension of idx should match that of the image."""
            pixelID = self.GetPixelIDValue()
            if pixelID == sitkUnknown:
               raise Exception("Logic Error: invalid pixel type")
            if pixelID == sitkUInt8 or pixelID == sitkLabelUInt8:
               return self.__SetPixelAsUInt8__( idx, value )
            if pixelID == sitkInt16:
               return self.__SetPixelAsInt16__( idx, value )
            if pixelID == sitkUInt16 or pixelID == sitkLabelUInt16:
               return self.__SetPixelAsUInt16__( idx, value )
            if pixelID == sitkInt32:
               return self.__SetPixelAsInt32__( idx, value )
            if pixelID == sitkUInt32 or pixelID == sitkLabelUInt32:
               return self.__SetPixelAsUInt32__( idx, value )
            if pixelID == sitkFloat32:
               return self.__SetPixelAsFloat__( idx, value )
            if pixelID == sitkFloat64:
               return self.__SetPixelAsDouble__( idx, value )
            raise Exception("Unknown pixel type")

        def GetPixel(self, *idx):
             """Returns the value of a pixel.

	     This method takes 2 parameters in 2D: the x and y index,
             and 3 parameters in 3D: the x, y and z index."""
             return self[idx]            

        def SetPixel(self, *args):
             """Sets the value of a pixel.

	     This method takes 3 parameters in 2D: the x and y index then the value,
             and 4 parameters in 3D: the x, y and z index then the value."""
             if len(args) < 2:
                raise Exception( "Wrong number of arguments, coordinates arguments then value" )
             idx = args[:len(args)-1]
             value = args[-1]
             self[idx] = value


         %}



};


#endif
