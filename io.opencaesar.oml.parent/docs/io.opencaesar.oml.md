# Abstract Syntax # {#oml}
The OML package specifies the abstract syntax (metamodel) of the Ontology Modeling Language using the [Ecore](https://www.eclipse.org/modeling/emf/) language.
Therefore, OML models are instances of this OML package and can be manipulated using the Java API induced by this package.
## Common ## {#group-Common}
<pre class=include>
path: images/oml-Common.svg
</pre>
### <dfn>*AnnotatedElement*</dfn> ### {#oml-AnnotatedElement}
	AnnotatedElement is an Element that may have a set of Annotations.
	
	*Super classes:*
	[=Element=]
	
	*Sub classes:*
	[=NamedElement=], [=NamedElementReference=], [=GraphStatement=], [=Axiom=], [=Assertion=]

	*Properties:*
	* **annotations** : [=Annotation=] [*]
	
		The set of annotations on this element			
### <dfn>Annotation</dfn> ### {#oml-Annotation}
	Annotation is an Element that provides a value for an AnnotationProperty placed on an [=AnnotatedElement=]. It does not have DL semantics.
	
	*Super classes:*
	[=Element=]
	

	*Properties:*
	* **property** : [=AnnotationProperty=]
	
		The annotation property that has the value			
	* **value** : [=LiteralValue=]
	
		The value of the annotation property			
### <dfn>*Element*</dfn> ### {#oml-Element}
	Element is the most abstract superclass of all objects in an OML model.
	
	
	*Sub classes:*
	[=Annotation=], [=AnnotatedElement=], [=GraphImport=], [=Instance=], [=LiteralValue=], [=Predicate=]

### <dfn>*NamedElement*</dfn> ### {#oml-NamedElement}
	NamedElement is an AnnotatedElement that has a name.
	
	*Super classes:*
	[=AnnotatedElement=]
	
	*Sub classes:*
	[=Graph=], [=GraphMember=]

	*Properties:*
	* **name** : String
	
		The name of the element
## Literals ## {#group-Literals}
<pre class=include>
path: images/oml-Literals.svg
</pre>
### <dfn>LiteralBoolean</dfn> ### {#oml-LiteralBoolean}
	
	*Super classes:*
	[=LiteralValue=]
	

	*Properties:*
	* **value** : Boolean
	
### <dfn>LiteralDateTime</dfn> ### {#oml-LiteralDateTime}
	
	*Super classes:*
	[=LiteralValue=]
	

	*Properties:*
	* **value** : String
	
### <dfn>LiteralDecimal</dfn> ### {#oml-LiteralDecimal}
	
	*Super classes:*
	[=LiteralNumber=]
	

	*Properties:*
	* **value** : BigDecimal
	
### <dfn>LiteralFloat</dfn> ### {#oml-LiteralFloat}
	
	*Super classes:*
	[=LiteralNumber=]
	

	*Properties:*
	* **value** : Float
	
### <dfn>*LiteralNumber*</dfn> ### {#oml-LiteralNumber}
	
	*Super classes:*
	[=LiteralValue=]
	
	*Sub classes:*
	[=LiteralReal=], [=LiteralRational=], [=LiteralFloat=], [=LiteralDecimal=]

### <dfn>LiteralRational</dfn> ### {#oml-LiteralRational}
	
	*Super classes:*
	[=LiteralNumber=]
	

	*Properties:*
	* **value** : Double
	
### <dfn>LiteralReal</dfn> ### {#oml-LiteralReal}
	
	*Super classes:*
	[=LiteralNumber=]
	

	*Properties:*
	* **value** : Double
	
### <dfn>LiteralString</dfn> ### {#oml-LiteralString}
	
	*Super classes:*
	[=LiteralValue=]
	

	*Properties:*
	* **value** : String
	
### <dfn>LiteralURI</dfn> ### {#oml-LiteralURI}
	
	*Super classes:*
	[=LiteralValue=]
	

	*Properties:*
	* **value** : String
	
### <dfn>LiteralUUID</dfn> ### {#oml-LiteralUUID}
	
	*Super classes:*
	[=LiteralValue=]
	

	*Properties:*
	* **value** : String
	
### <dfn>*LiteralValue*</dfn> ### {#oml-LiteralValue}
	
	*Super classes:*
	[=Element=]
	
	*Sub classes:*
	[=LiteralBoolean=], [=LiteralDateTime=], [=LiteralString=], [=LiteralUUID=], [=LiteralURI=], [=LiteralNumber=]

	*Properties:*
	* **valueType** : [=ScalarRange=]
	
## Graphs ## {#group-Graphs}
<pre class=include>
path: images/oml-Graphs.svg
</pre>
### <dfn>Description</dfn> ### {#oml-Description}
	Description is a Graph that contains DescriptionStatements and may import other Descriptions.
	
	*Super classes:*
	[=Graph=]
	

	*Properties:*
	* **kind** : [=DescriptionKind=]
	
		The kind of description
	* **imports** : [=DescriptionImport=] [*]
	
		The set of direct imports of other descriptions			
	* **statements** : [=DescriptionStatement=] [*]
	
		The set of statements in the description			
### <dfn>*DescriptionImport*</dfn> ### {#oml-DescriptionImport}
	
	*Super classes:*
	[=GraphImport=]
	
	*Sub classes:*
	[=DescriptionUsage=], [=DescriptionRefinement=]

### <dfn>DescriptionKind</dfn> ### {#oml-DescriptionKind}
	DescriptionKind is an enumeration of the kinds of Description.
			
	*Literals:*
	* **Final**
	
		Specifies that the description is final, i.e., cannot be refined further
	* **Partial**
	
		Specifies that the description is partial, i.e., is expected to be refined further
### <dfn>*DescriptionMember*</dfn> ### {#oml-DescriptionMember}
	
	*Super classes:*
	[=DescriptionStatement=], [=GraphMember=]
	
	*Sub classes:*
	[=NamedInstance=]

### <dfn>DescriptionRefinement</dfn> ### {#oml-DescriptionRefinement}
	
	*Super classes:*
	[=DescriptionImport=]
	

### <dfn>*DescriptionStatement*</dfn> ### {#oml-DescriptionStatement}
	
	*Super classes:*
	[=GraphStatement=]
	
	*Sub classes:*
	[=DescriptionMember=], [=DescriptionMemberReference=]

### <dfn>DescriptionUsage</dfn> ### {#oml-DescriptionUsage}
	
	*Super classes:*
	[=DescriptionImport=]
	

### <dfn>*Graph*</dfn> ### {#oml-Graph}
	Graph is a NamedElement that represents the root of containment in an OML model. The name of the graph is an alias to its base IRI.
	
	*Super classes:*
	[=NamedElement=]
	
	*Sub classes:*
	[=Terminology=], [=Description=]

	*Properties:*
	* **iri** : String
	
		The base IRI representing the namespace of the graph
### <dfn>*GraphImport*</dfn> ### {#oml-GraphImport}
	
	*Super classes:*
	[=Element=]
	
	*Sub classes:*
	[=TerminologyImport=], [=DescriptionImport=]

	*Properties:*
	* **importURI** : String
	
	* **importedNamespace** : String
	
### <dfn>*GraphMember*</dfn> ### {#oml-GraphMember}
	GraphMember is a NamedElement that is a member of a [=Graph=].
	
	*Super classes:*
	[=NamedElement=]
	
	*Sub classes:*
	[=TerminologyMember=], [=DescriptionMember=]

### <dfn>*GraphStatement*</dfn> ### {#oml-GraphStatement}
	
	*Super classes:*
	[=AnnotatedElement=]
	
	*Sub classes:*
	[=TerminologyStatement=], [=DescriptionStatement=]

### <dfn>Terminology</dfn> ### {#oml-Terminology}
	Terminology is a Graph that contains TerminologyStatements and may import other Terminologies.
	
	*Super classes:*
	[=Graph=]
	

	*Properties:*
	* **kind** : [=TerminologyKind=]
	
		The kind of terminology
	* **imports** : [=TerminologyImport=] [*]
	
		The set of direct imports of other terminologies			
	* **statements** : [=TerminologyStatement=] [*]
	
		The set of statements in the terminology			
### <dfn>TerminologyExtension</dfn> ### {#oml-TerminologyExtension}
	
	*Super classes:*
	[=TerminologyImport=]
	

### <dfn>*TerminologyImport*</dfn> ### {#oml-TerminologyImport}
	
	*Super classes:*
	[=GraphImport=]
	
	*Sub classes:*
	[=TerminologyExtension=]

### <dfn>TerminologyKind</dfn> ### {#oml-TerminologyKind}
	TerminologyKind is an enumeration of the kinds of Terminology.
			
	*Literals:*
	* **Open**
	
		Specifies that the terminology has open-world semantics
	* **Closed**
	
		Specifies that the terminology has closed-world semantics
### <dfn>*TerminologyMember*</dfn> ### {#oml-TerminologyMember}
	TerminologyMember is a GraphMember that is a member of a [=Terminology=].
	
	*Super classes:*
	[=GraphMember=]
	
	*Sub classes:*
	[=Term=], [=Rule=], [=RelationshipDirection=]

### <dfn>*TerminologyStatement*</dfn> ### {#oml-TerminologyStatement}
	
	*Super classes:*
	[=GraphStatement=]
	
	*Sub classes:*
	[=Term=], [=Rule=], [=TerminologyMemberReference=]

## Terms ## {#group-Terms}
<pre class=include>
path: images/oml-Terms.svg
</pre>
### <dfn>AnnotationProperty</dfn> ### {#oml-AnnotationProperty}
	
	*Super classes:*
	[=Property=]
	

### <dfn>*CharacterizableTerm*</dfn> ### {#oml-CharacterizableTerm}
	CharacterizableTerm is a Term that can be characterized by properties.
	
	*Super classes:*
	[=Term=]
	
	*Sub classes:*
	[=Entity=], [=Structure=]

### <dfn>*CharacterizationProperty*</dfn> ### {#oml-CharacterizationProperty}
	
	*Super classes:*
	[=Property=]
	
	*Sub classes:*
	[=StructuredProperty=], [=ScalarProperty=]

	*Properties:*
	* **functional** : Boolean
	
	* **domain** : [=CharacterizableTerm=]
	
### <dfn>*Property*</dfn> ### {#oml-Property}
	
	*Super classes:*
	[=Term=]
	
	*Sub classes:*
	[=CharacterizationProperty=], [=AnnotationProperty=]

### <dfn>ScalarProperty</dfn> ### {#oml-ScalarProperty}
	
	*Super classes:*
	[=CharacterizationProperty=]
	

	*Properties:*
	* **range** : [=ScalarRange=]
	
### <dfn>StructuredProperty</dfn> ### {#oml-StructuredProperty}
	
	*Super classes:*
	[=CharacterizationProperty=]
	

	*Properties:*
	* **range** : [=Structure=]
	
### <dfn>*Term*</dfn> ### {#oml-Term}
	Term is a TerminologyMember and TerminologyStatement that is defined by a [=Terminology=] and can be specialized in a hierarchy.
	
	*Super classes:*
	[=TerminologyMember=], [=TerminologyStatement=]
	
	*Sub classes:*
	[=CharacterizableTerm=], [=Relationship=], [=ScalarRange=], [=Property=]

	*Properties:*
	* **specializations** : [=TermSpecializationAxiom=] [*]
	
		The set of specializations of the term			
## Class Terms ## {#group-ClassTerms}
<pre class=include>
path: images/oml-ClassTerms.svg
</pre>
### <dfn>Aspect</dfn> ### {#oml-Aspect}
	Aspect is an Entity that defines cross-cutting characterizations that can be mixed with those of other Entities.
	
	*Super classes:*
	[=Entity=]
	

### <dfn>Concept</dfn> ### {#oml-Concept}
	Concept is an Entity that represents a concrete class of objects or ideas.
	
	*Super classes:*
	[=Entity=]
	

### <dfn>*Entity*</dfn> ### {#oml-Entity}
	Entity is a CharacterizableTerm that can be interrelated and restricted.
	
	*Super classes:*
	[=CharacterizableTerm=]
	
	*Sub classes:*
	[=Aspect=], [=Concept=], [=ReifiedRelationship=]

	*Properties:*
	* **restrictions** : [=EntityRestrictionAxiom=] [*]
	
		The set of restriction axioms on the Entity's properties			
### <dfn>ForwardDirection</dfn> ### {#oml-ForwardDirection}
	
	*Super classes:*
	[=RelationshipDirection=]
	

### <dfn>InverseDirection</dfn> ### {#oml-InverseDirection}
	
	*Super classes:*
	[=RelationshipDirection=]
	

### <dfn>ReifiedRelationship</dfn> ### {#oml-ReifiedRelationship}
	ReifiedRelationship is a Relationship that is also reified as an Entity, i.e., can be characterized and interrelated.
	
	*Super classes:*
	[=Entity=], [=Relationship=]
	

### <dfn>*Relationship*</dfn> ### {#oml-Relationship}
	Relationship is a Term that represents a relationship from a source Term to a target Term.
	
	*Super classes:*
	[=Term=]
	
	*Sub classes:*
	[=ReifiedRelationship=], [=UnreifiedRelationship=]

	*Properties:*
	* **functional** : Boolean
	
		Whether the Relationship is functional (A->B and A->C => B=C)
	* **inverseFunctional** : Boolean
	
		Whether the Relationship is inverse functional (B->A and C->A => B=C)
	* **symmetric** : Boolean
	
		Whether the Relationship is symmetric (A->B => B->A)
	* **asymmetric** : Boolean
	
		Whether the Relationship is asymmetric (A->B => B!->A)
	* **reflexive** : Boolean
	
		Whether the Relationship is reflexive (A => A->A)
	* **irreflexive** : Boolean
	
		Whether the Relationship is reflexive (A => A!->A)
	* **transitive** : Boolean
	
		Whether the Relationship is reflexive (A->B and B->C => A->C)
	* **source** : [=Entity=]
	
		The source Term of the Relationship			
	* **target** : [=Entity=]
	
		The target Term of the Relationship			
	* **forward** : [=ForwardDirection=]
	
		The forward direction of the relationship			
	* **inverse** : [=InverseDirection=]
	
		The inverse direction of the relationship			
### <dfn>*RelationshipDirection*</dfn> ### {#oml-RelationshipDirection}
	
	*Super classes:*
	[=TerminologyMember=]
	
	*Sub classes:*
	[=ForwardDirection=], [=InverseDirection=]

### <dfn>UnreifiedRelationship</dfn> ### {#oml-UnreifiedRelationship}
	UnreifiedRelationship is a Relationship that is not reified but represents a simple reference
	
	*Super classes:*
	[=Relationship=]
	

## Data Terms ## {#group-DataTerms}
<pre class=include>
path: images/oml-DataTerms.svg
</pre>
### <dfn>BinaryScalar</dfn> ### {#oml-BinaryScalar}
	BinaryScalar is a CharArrayScalar whose literals represent binary numbers, i.e., arrays of 0 and 1 digits.
	
	*Super classes:*
	[=CharArrayScalar=]
	

### <dfn>*CharArrayScalar*</dfn> ### {#oml-CharArrayScalar}
	CharArrayScalar is a ScalarRange that specializes another ScalarRange, whose literals are represented as character arrays,
	and may restrict some facets of those arrays.
	
	*Super classes:*
	[=ScalarRange=]
	
	*Sub classes:*
	[=BinaryScalar=], [=PatternScalar=]

	*Properties:*
	* **length** : Integer
	
		The exact length of the character array
	* **minLength** : Integer
	
		The minimum length of the character array
	* **maxLength** : Integer
	
		The maximum length of the character array
### <dfn>EnumerationScalar</dfn> ### {#oml-EnumerationScalar}
	EnumerationScalar is a ScalarRange whose literals are enumerated and cannot specialize other ScalarRanges.
	
	*Super classes:*
	[=ScalarRange=]
	

	*Properties:*
	* **literals** : [=LiteralValue=] [*]
	
		The set of valid enumerated literals			
### <dfn>IRIScalar</dfn> ### {#oml-IRIScalar}
	IRIScalar is a PatternScalar whose literals represent IRIs.
	
	*Super classes:*
	[=PatternScalar=]
	

### <dfn>NumericScalar</dfn> ### {#oml-NumericScalar}
	NumericScalar is a ScalarRange that specializes another ScalarRange, whose literals represent a numeric range,
	and may restrict some facets of that range.
	
	*Super classes:*
	[=ScalarRange=]
	

	*Properties:*
	* **minInclusive** : [=LiteralNumber=]
	
		The minimum inclusive value of the numeric range			
	* **minExclusive** : [=LiteralNumber=]
	
		The minimum exclusive value of the numeric range			
	* **maxInclusive** : [=LiteralNumber=]
	
		The maximum inclusive value of the numeric range			
	* **maxExclusive** : [=LiteralNumber=]
	
		The maximum exclusive value of the numeric range			
### <dfn>*PatternScalar*</dfn> ### {#oml-PatternScalar}
	PatternScalar is a CharArrayScalar whose literals lexically conform to a pattern specified by a regex expression.
	
	*Super classes:*
	[=CharArrayScalar=]
	
	*Sub classes:*
	[=IRIScalar=], [=PlainLiteralScalar=], [=StringScalar=]

	*Properties:*
	* **pattern** : String
	
		The regex expression of the pattern
### <dfn>PlainLiteralScalar</dfn> ### {#oml-PlainLiteralScalar}
	PlainLiteralScalar is a PatternScalar whose literals belong to a given language.
	
	*Super classes:*
	[=PatternScalar=]
	

	*Properties:*
	* **language** : String
	
		The tag of the language of the literals. See this [reference](https://www.w3.org/TR/2012/REC-rdf-plain-literal-20121211/) for more details.
### <dfn>Scalar</dfn> ### {#oml-Scalar}
	Scalar is a ScalarRange that does not specialize other ScalarRanges.
	
	*Super classes:*
	[=ScalarRange=]
	

### <dfn>*ScalarRange*</dfn> ### {#oml-ScalarRange}
	ScalarRange is a Term that represents the abstract superclass of all ScalarRanges.
	
	*Super classes:*
	[=Term=]
	
	*Sub classes:*
	[=Scalar=], [=CharArrayScalar=], [=NumericScalar=], [=TimeScalar=], [=EnumerationScalar=]

### <dfn>StringScalar</dfn> ### {#oml-StringScalar}
	StringScalar is a PatternScalar whose literals represent arbitrary string values.
	
	*Super classes:*
	[=PatternScalar=]
	

### <dfn>Structure</dfn> ### {#oml-Structure}
	Structure is a CharacterizableTerm that can be specified by value (i.e., cannot be referenced).
	
	*Super classes:*
	[=CharacterizableTerm=]
	

### <dfn>TimeScalar</dfn> ### {#oml-TimeScalar}
	TimeScalar is a ScalarRange that specializes another ScalarRange, whose literals represent time range,
	and may restrict some facets of that range.
	
	*Super classes:*
	[=ScalarRange=]
	

	*Properties:*
	* **minInclusive** : [=LiteralDateTime=]
	
		The minimum inclusive value of the time range			
	* **minExclusive** : [=LiteralDateTime=]
	
		The minimum exclusive value of the time range			
	* **maxInclusive** : [=LiteralDateTime=]
	
		The maximum inclusive value of the time range			
	* **maxExclusive** : [=LiteralDateTime=]
	
		The maximum exclusive value of the time range			
## Axioms ## {#group-Axioms}
<pre class=include>
path: images/oml-Axioms.svg
</pre>
### <dfn>*Axiom*</dfn> ### {#oml-Axiom}
	
	*Super classes:*
	[=AnnotatedElement=]
	
	*Sub classes:*
	[=TermSpecializationAxiom=], [=EntityRestrictionAxiom=]

### <dfn>*EntityRestrictionAxiom*</dfn> ### {#oml-EntityRestrictionAxiom}
	
	*Super classes:*
	[=Axiom=]
	
	*Sub classes:*
	[=RelationshipRestrictionAxiom=], [=ScalarPropertyRestrictionAxiom=], [=StructuredPropertyRestrictionAxiom=]

### <dfn>ExistentialRelationshipRestrictionAxiom</dfn> ### {#oml-ExistentialRelationshipRestrictionAxiom}
	
	*Super classes:*
	[=RelationshipRestrictionAxiom=]
	

### <dfn>ExistentialScalarPropertyRestrictionAxiom</dfn> ### {#oml-ExistentialScalarPropertyRestrictionAxiom}
	
	*Super classes:*
	[=TypedScalarPropertyRestrictionAxion=]
	

### <dfn>ParticularScalarPropertyRestrictionAxiom</dfn> ### {#oml-ParticularScalarPropertyRestrictionAxiom}
	
	*Super classes:*
	[=ScalarPropertyRestrictionAxiom=]
	

	*Properties:*
	* **value** : [=LiteralValue=]
	
### <dfn>*RelationshipRestrictionAxiom*</dfn> ### {#oml-RelationshipRestrictionAxiom}
	
	*Super classes:*
	[=EntityRestrictionAxiom=]
	
	*Sub classes:*
	[=ExistentialRelationshipRestrictionAxiom=], [=UniversalRelationshipRestrictionAxiom=]

	*Properties:*
	* **relationshipDirection** : [=RelationshipDirection=]
	
	* **restrictedTo** : [=Entity=]
	
### <dfn>*ScalarPropertyRestrictionAxiom*</dfn> ### {#oml-ScalarPropertyRestrictionAxiom}
	
	*Super classes:*
	[=EntityRestrictionAxiom=]
	
	*Sub classes:*
	[=TypedScalarPropertyRestrictionAxion=], [=ParticularScalarPropertyRestrictionAxiom=]

	*Properties:*
	* **property** : [=ScalarProperty=]
	
### <dfn>StructuredPropertyRestrictionAxiom</dfn> ### {#oml-StructuredPropertyRestrictionAxiom}
	
	*Super classes:*
	[=EntityRestrictionAxiom=]
	

	*Properties:*
	* **property** : [=StructuredProperty=]
	
	* **value** : [=StructureInstance=]
	
### <dfn>TermSpecializationAxiom</dfn> ### {#oml-TermSpecializationAxiom}
	
	*Super classes:*
	[=Axiom=]
	

	*Properties:*
	* **specializedTerm** : [=Term=]
	
### <dfn>*TypedScalarPropertyRestrictionAxion*</dfn> ### {#oml-TypedScalarPropertyRestrictionAxion}
	
	*Super classes:*
	[=ScalarPropertyRestrictionAxiom=]
	
	*Sub classes:*
	[=ExistentialScalarPropertyRestrictionAxiom=], [=UniversalScalarPropertyRestrictionAxiom=]

	*Properties:*
	* **restrictedTo** : [=ScalarRange=]
	
### <dfn>UniversalRelationshipRestrictionAxiom</dfn> ### {#oml-UniversalRelationshipRestrictionAxiom}
	
	*Super classes:*
	[=RelationshipRestrictionAxiom=]
	

### <dfn>UniversalScalarPropertyRestrictionAxiom</dfn> ### {#oml-UniversalScalarPropertyRestrictionAxiom}
	
	*Super classes:*
	[=TypedScalarPropertyRestrictionAxion=]
	

## Rules ## {#group-Rules}
<pre class=include>
path: images/oml-Rules.svg
</pre>
### <dfn>DirectionalRelationshipPredicate</dfn> ### {#oml-DirectionalRelationshipPredicate}
	
	*Super classes:*
	[=RelationshipPredicate=]
	

	*Properties:*
	* **relationshipDirection** : [=RelationshipDirection=]
	
### <dfn>EntityPredicate</dfn> ### {#oml-EntityPredicate}
	
	*Super classes:*
	[=Predicate=]
	

	*Properties:*
	* **variable** : String
	
	* **entity** : [=Entity=]
	
### <dfn>*Predicate*</dfn> ### {#oml-Predicate}
	
	*Super classes:*
	[=Element=]
	
	*Sub classes:*
	[=EntityPredicate=], [=RelationshipPredicate=]

### <dfn>ReifiedRelationshipPredicate</dfn> ### {#oml-ReifiedRelationshipPredicate}
	
	*Super classes:*
	[=RelationshipPredicate=]
	

	*Properties:*
	* **kind** : [=ReifiedRelationshipPredicateKind=]
	
	* **relationship** : [=ReifiedRelationship=]
	
### <dfn>ReifiedRelationshipPredicateKind</dfn> ### {#oml-ReifiedRelationshipPredicateKind}
			
	*Literals:*
	* **Source**
	
	* **InverseSource**
	
	* **Target**
	
	* **InverseTarget**
	
### <dfn>*RelationshipPredicate*</dfn> ### {#oml-RelationshipPredicate}
	
	*Super classes:*
	[=Predicate=]
	
	*Sub classes:*
	[=DirectionalRelationshipPredicate=], [=ReifiedRelationshipPredicate=]

	*Properties:*
	* **variable1** : String
	
	* **variable2** : String
	
### <dfn>Rule</dfn> ### {#oml-Rule}
	
	*Super classes:*
	[=TerminologyMember=], [=TerminologyStatement=]
	

	*Properties:*
	* **antecedent** : [=Predicate=] [*]
	
	* **consequent** : [=DirectionalRelationshipPredicate=]
	
## Instances ## {#group-Instances}
<pre class=include>
path: images/oml-Instances.svg
</pre>
### <dfn>ConceptInstance</dfn> ### {#oml-ConceptInstance}
	
	*Super classes:*
	[=NamedInstance=]
	

	*Properties:*
	* **types** : [=Assertion=] [*]
	
### <dfn>*Instance*</dfn> ### {#oml-Instance}
	
	*Super classes:*
	[=Element=]
	
	*Sub classes:*
	[=NamedInstance=], [=StructureInstance=]

	*Properties:*
	* **propertyValues** : [=InstancePropertyValueAssertion=] [*]
	
### <dfn>*NamedInstance*</dfn> ### {#oml-NamedInstance}
	
	*Super classes:*
	[=DescriptionMember=], [=Instance=]
	
	*Sub classes:*
	[=ConceptInstance=], [=ReifiedRelationshipInstance=]

### <dfn>ReifiedRelationshipInstance</dfn> ### {#oml-ReifiedRelationshipInstance}
	
	*Super classes:*
	[=NamedInstance=]
	

	*Properties:*
	* **types** : [=ReifiedRelationshipInstanceTypeAssertion=] [*]
	
	* **source** : [=NamedInstance=]
	
	* **target** : [=NamedInstance=]
	
### <dfn>StructureInstance</dfn> ### {#oml-StructureInstance}
	
	*Super classes:*
	[=Instance=]
	

	*Properties:*
	* **structure** : [=Structure=]
	
## Assertions ## {#group-Assertions}
<pre class=include>
path: images/oml-Assertions.svg
</pre>
### <dfn>*Assertion*</dfn> ### {#oml-Assertion}
	
	*Super classes:*
	[=AnnotatedElement=]
	
	*Sub classes:*
	[=ConceptInstanceTypeAssertion=], [=ReifiedRelationshipInstanceTypeAssertion=], [=InstancePropertyValueAssertion=]

### <dfn>ConceptInstanceTypeAssertion</dfn> ### {#oml-ConceptInstanceTypeAssertion}
	
	*Super classes:*
	[=Assertion=]
	

	*Properties:*
	* **concept** : [=Concept=]
	
### <dfn>*InstancePropertyValueAssertion*</dfn> ### {#oml-InstancePropertyValueAssertion}
	
	*Super classes:*
	[=Assertion=]
	
	*Sub classes:*
	[=ScalarPropertyValueAssertion=], [=StructuredPropertyValueAssertion=]

### <dfn>ReifiedRelationshipInstanceTypeAssertion</dfn> ### {#oml-ReifiedRelationshipInstanceTypeAssertion}
	
	*Super classes:*
	[=Assertion=]
	

	*Properties:*
	* **relationship** : [=ReifiedRelationship=]
	
### <dfn>ScalarPropertyValueAssertion</dfn> ### {#oml-ScalarPropertyValueAssertion}
	
	*Super classes:*
	[=InstancePropertyValueAssertion=]
	

	*Properties:*
	* **property** : [=ScalarProperty=]
	
	* **value** : [=LiteralValue=]
	
### <dfn>StructuredPropertyValueAssertion</dfn> ### {#oml-StructuredPropertyValueAssertion}
	
	*Super classes:*
	[=InstancePropertyValueAssertion=]
	

	*Properties:*
	* **property** : [=StructuredProperty=]
	
	* **value** : [=StructureInstance=]
	
## References ## {#group-References}
<pre class=include>
path: images/oml-References.svg
</pre>
### <dfn>*GraphMemberReference*</dfn> ### {#oml-GraphMemberReference}
	
	*Super classes:*
	[=NamedElementReference=]
	
	*Sub classes:*
	[=TerminologyMemberReference=], [=DescriptionMemberReference=]

### <dfn>*NamedElementReference*</dfn> ### {#oml-NamedElementReference}
	
	*Super classes:*
	[=AnnotatedElement=]
	
	*Sub classes:*
	[=GraphMemberReference=]

## Terminology References ## {#group-TerminologyReferences}
<pre class=include>
path: images/oml-TerminologyReferences.svg
</pre>
### <dfn>AspectReference</dfn> ### {#oml-AspectReference}
	
	*Super classes:*
	[=EntityReference=]
	

	*Properties:*
	* **aspect** : [=Aspect=]
	
### <dfn>ConceptReference</dfn> ### {#oml-ConceptReference}
	
	*Super classes:*
	[=EntityReference=]
	

	*Properties:*
	* **concept** : [=Concept=]
	
### <dfn>*EntityReference*</dfn> ### {#oml-EntityReference}
	
	*Super classes:*
	[=TermReference=]
	
	*Sub classes:*
	[=AspectReference=], [=ConceptReference=], [=ReifiedRelationshipReference=]

	*Properties:*
	* **restrictions** : [=EntityRestrictionAxiom=] [*]
	
### <dfn>ReifiedRelationshipReference</dfn> ### {#oml-ReifiedRelationshipReference}
	
	*Super classes:*
	[=EntityReference=]
	

	*Properties:*
	* **relationship** : [=ReifiedRelationship=]
	
### <dfn>RelationshipDirectionReference</dfn> ### {#oml-RelationshipDirectionReference}
	
	*Super classes:*
	[=TerminologyMemberReference=]
	

	*Properties:*
	* **direction** : [=RelationshipDirection=]
	
### <dfn>RuleReference</dfn> ### {#oml-RuleReference}
	
	*Super classes:*
	[=TerminologyMemberReference=]
	

	*Properties:*
	* **rule** : [=Rule=]
	
### <dfn>ScalarPropertyReference</dfn> ### {#oml-ScalarPropertyReference}
	
	*Super classes:*
	[=TermReference=]
	

	*Properties:*
	* **property** : [=ScalarProperty=]
	
### <dfn>ScalarRangeReference</dfn> ### {#oml-ScalarRangeReference}
	
	*Super classes:*
	[=TermReference=]
	

	*Properties:*
	* **scalar** : [=ScalarRange=]
	
### <dfn>StructureReference</dfn> ### {#oml-StructureReference}
	
	*Super classes:*
	[=TermReference=]
	

	*Properties:*
	* **structure** : [=Structure=]
	
### <dfn>StructuredPropertyReference</dfn> ### {#oml-StructuredPropertyReference}
	
	*Super classes:*
	[=TermReference=]
	

	*Properties:*
	* **property** : [=StructuredProperty=]
	
### <dfn>*TermReference*</dfn> ### {#oml-TermReference}
	
	*Super classes:*
	[=TerminologyMemberReference=]
	
	*Sub classes:*
	[=EntityReference=], [=UnreifiedRelationshipReference=], [=StructureReference=], [=ScalarRangeReference=], [=StructuredPropertyReference=], [=ScalarPropertyReference=]

	*Properties:*
	* **specializations** : [=TermSpecializationAxiom=] [*]
	
### <dfn>*TerminologyMemberReference*</dfn> ### {#oml-TerminologyMemberReference}
	
	*Super classes:*
	[=GraphMemberReference=], [=TerminologyStatement=]
	
	*Sub classes:*
	[=TermReference=], [=RelationshipDirectionReference=], [=RuleReference=]

### <dfn>UnreifiedRelationshipReference</dfn> ### {#oml-UnreifiedRelationshipReference}
	
	*Super classes:*
	[=TermReference=]
	

	*Properties:*
	* **relationship** : [=UnreifiedRelationship=]
	
## Description References ## {#group-DescriptionReferences}
<pre class=include>
path: images/oml-DescriptionReferences.svg
</pre>
### <dfn>ConceptInstanceReference</dfn> ### {#oml-ConceptInstanceReference}
	
	*Super classes:*
	[=NamedInstanceReference=]
	

	*Properties:*
	* **instance** : [=ConceptInstance=]
	
	* **types** : [=ConceptInstanceTypeAssertion=] [*]
	
### <dfn>*DescriptionMemberReference*</dfn> ### {#oml-DescriptionMemberReference}
	
	*Super classes:*
	[=DescriptionStatement=], [=GraphMemberReference=]
	
	*Sub classes:*
	[=NamedInstanceReference=]

### <dfn>*NamedInstanceReference*</dfn> ### {#oml-NamedInstanceReference}
	
	*Super classes:*
	[=DescriptionMemberReference=]
	
	*Sub classes:*
	[=ConceptInstanceReference=], [=ReifiedRelationshipInstanceReference=]

	*Properties:*
	* **propertyValues** : [=InstancePropertyValueAssertion=] [*]
	
### <dfn>ReifiedRelationshipInstanceReference</dfn> ### {#oml-ReifiedRelationshipInstanceReference}
	
	*Super classes:*
	[=NamedInstanceReference=]
	

	*Properties:*
	* **instance** : [=ReifiedRelationshipInstance=]
	
	* **types** : [=ReifiedRelationshipInstanceTypeAssertion=] [*]
	
