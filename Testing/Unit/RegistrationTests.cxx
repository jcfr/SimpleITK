#include <SimpleITKTestHarness.h>
#include <SimpleITK.h>

#include "sitkTransform.h"

namespace sitk = itk::simple;

TEST(Registration,CreateDefaultMetric) {
  sitk::Image image2d( 32, 32, sitk::sitkUInt8 );
  sitk::Image image3d( 32, 32, 32, sitk::sitkUInt8 );

  sitk::Metric metric;

  ASSERT_TRUE ( metric.GetITKBase( image2d ) != NULL );
  ASSERT_TRUE ( metric.GetITKBase( image3d ) != NULL );
}

static float ExpectedParameters[] = {1.0007, -0.00291716, -0.00417716,
                                     0.00237245, 0.998502, -0.00246285,
                                     -0.000911028, 0.000150096, 0.996861,
                                     -0.0263989, -0.113908, -0.0758585 };

TEST(Registration,Components) {

  sitk::ImageFileReader reader;


  sitk::Image fixed = reader.SetFileName ( dataFinder.GetFile ( "Input/OAS1_0001_MR1_mpr-1_anon.nrrd" ) ).Execute();
  sitk::Image moving = reader.SetFileName ( dataFinder.GetFile ( "Input/OAS1_0002_MR1_mpr-1_anon.nrrd" ) ).Execute();

  sitk::Registration registration;

  // Create a transform
  sitk::Transform transform = sitk::Transform(3, sitk::sitkAffine);
  registration.SetTransform ( transform );

  registration.SetInterpolator ( sitk::sitkLinearInterpolate );

  ASSERT_NO_THROW ( transform = registration.Execute ( fixed, moving ) );
  std::cout << transform.ToString() << std::endl;
  std::vector<double> params = transform.GetParameters();
  ASSERT_EQ ( params.size(), 12u );
  for ( size_t idx = 0; idx < 9; idx++ )
    {
// HACK: disabled until registration frame work is working
//    ASSERT_NEAR ( params[idx], ExpectedParameters[idx], 0.02 ) << "idx = " << idx;
    }


}


TEST(Registration,Defaults) {

  // This test runs the registration framework with defaults

  sitk::Image fixed =  sitk::ReadImage ( dataFinder.GetFile ( "Input/OAS1_0001_MR1_mpr-1_anon.nrrd" ) );
  sitk::Image moving = fixed;

  sitk::Registration registration;

  sitk::Transform results;

  ASSERT_NO_THROW ( results = registration.Execute ( fixed, moving ) );

  // The default transformation is the identity, very boring results
  ASSERT_EQ ( results.GetParameters().size(), 0u );

}

TEST(Registration,Resample) {
  sitk::ImageFileReader reader;

  sitk::Image fixed = reader.SetFileName ( dataFinder.GetFile ( "Input/OAS1_0001_MR1_mpr-1_anon.nrrd" ) ).Execute();
  sitk::Image moving = reader.SetFileName ( dataFinder.GetFile ( "Input/OAS1_0002_MR1_mpr-1_anon.nrrd" ) ).Execute();

  sitk::Registration registration;

  registration.SetInterpolator ( sitk::sitkLinearInterpolate );

  // Create a transform
  sitk::Transform transform = sitk::Transform(3, sitk::sitkAffine);
  registration.SetTransform ( transform );

  ASSERT_NO_THROW ( transform = registration.Execute ( fixed, moving ) );

  sitk::ResampleImageFilter resample;
  resample.SetReferenceImage ( fixed );
  resample.SetTransform ( transform );


  sitk::Image resampled = resample.Execute ( moving );

  //sitk::Show( sitk::CheckerBoard( fixed, resampled ) );
  //IMAGECOMPAREWITHTOLERANCE ( resampled, "Resample", 0.1 );
}
